# Pundat Archiver

[Pundat](https://github.com/gtfierro/pundat) subscribes to data published over BOSSWAVE and saves it in BTrDB.
Pundat should be run on the same cluster or node as your BTrDB installation.

## Configuration

### BOSSWAVE Entity

Pundat operates by listening on a set of BOSSWAVE namespaces for archive request messages (documented below) which contain instructions on what streams of data to archive.
For this to work, Pundat needs to be configured with a BOSSWAVE entity (`$PUNDAT_ENTITY`) with subsscription access to each stream it wants to archive.
Create the entity and place it in a known location that you don't mind being mounted into a docker container (such as `/etc/pundat`).

The easiest way to do this is just to grant the following DoT

```
bw2 mkdot -f $PRIVILEGED_ENTITY -t $PUNDAT_ENTITY -u $NAMESPACE/* -x C* -m "Pundat access to namespace"
```

If you want more fine-grained control, then you can grant the following DoT to (`$PUNDAT_ENTITY`) to have it discover archive requests

```
bw2 mkdot -f $PRIVILEGED_ENTITY -t $PUNDAT_ENTITY -u '$NAMESPACE/*/!meta/archiverequest' -x 'C*' -m "Pundat discover archive requests"
```

and then grant a direct subscription DoT for each individual stream

```
bw2 mkdot -f $PRIVILEGED_ENTITY -t $PUNDAT_ENTITY -u '$NAMESPACE/sensors/s.sensor/123/i.xbos.temperature_sensor/signal/info' -m 'archiver access to sensor stream'
```

Keep in mind this is very tedious and error-prone.

---

`$PUNDAT_ENTITY` also needs permission to operate on a namespace (`$GILES_BW_NAMESPACE`). The DoT to grant is

```
bw2 mkdot -f $PRIVILEGED_ENTITY -t $PUNDAT_ENTITY -u $NAMESPACE/s.giles/* -x PC*
```

### Environment Variables

The other environment variables Pundat expects are:
- `BTRDB_SERVER`: this is the local address and port of your BTrDB endpoint
- `MONGO_SERVER`: this is the local address and port of a MongoDB server (does not need persistent storage)
- `GILES_BW_ENTITY`: this is the container-local path to the entity Pundat should use
- `GILES_BW_NAMESPACE`: this is the namespace Pundat operates on
- `GILES_BW_ADDRESS`: this is the address of the BOSSWAVE agent Pundat should use. If Pundat is running in a Docker container (either through Kubernetes or otherwise), then we recommend configuring the BOSSWAVE agent to listen on the default Docker interface. In the BOSSWAVE config file `/etc/bw2/bw2.ini`, make sure you have the following lines:
    ```
    [oob]
    ListenOn=172.17.0.1:28589
    ```
- `GILES_BW_LSTEN`: this is a space-separated list of all of the namespaces Pundat wants to subscribe to
- `COLLECTION_PREFIX`: this is the prefix Pundat adds to its collection names for MongoDB, which helps avoid collisions.

## Installation

Pundat is shipped as a Docker container image `gtfierro/pundat:latest` (most recent version is `gtfierro/pundat:0.3.4`). You can build this container yourself by running `make container` in a cloned copy of the [Pundat repository](https://github.com/gtfierro/PunDat).

### Run with Kubernetes

If you are running Kubernetes on your node/cluster, then you can easily install Pundat by using its Kubernetes file

```bash
curl -O https://github.com/gtfierro/pundat/blob/master/kubernetes/pundat.yaml
# edit pundat.yaml
kubectl create -f pundat.yaml
```

### Run with Docker

If you are not running Kubernetes, you can invoke the Pundat container directly

```bash
# install jq:  https://stedolan.github.io/jq/
docker run -d --name pundat-mongo mongo:latest
MONGOIP=$(docker inspect pundat-mongo | jq .[0].NetworkSettings.Networks.bridge.IPAddress | tr -d '"')
docker run -d --name pundat -e BTRDB_SERVER=<btrdb ip>:4410 \
                            -e MONGO_SERVER=$MONGOIP:27017 \
                            -e GILES_BW_ENTITY=/etc/pundat/<archiver entity.ent> \
                            -e GILES_BW_NAMESPACE=<namespace to deploy on> \
                            -e GILES_BW_ADDRESS=172.17.0.1:28589 \
                            -e GILES_BW_LSTEN="space-separated list of namespaces to listen on" \
                            -e COLLECTION_PREFIX="pundat_" \
                            -v <host config directory>:/etc/pundat \
                            gtfierro/pundat:latest
```

## Archiving

A **stream** is the unit of archival and data access. A stream consists of:
* a timeseries (a single progression of `<time, value>` pairs)
* metadata (a bag of `key = value` pairs)
* a UUID (a unique 16-byte identifier)

In BOSSWAVE, drivers simply push their data into the overlay network where anyone with permission can listen to the data. In order to archive data in BOSSWAVE, instead of explicitly instructing a driver to push data to a particular archiver (which would require prior knowledge of an archiver), we instead tell the archiver to listen to URIs on which drivers or services publish data.

Upon startup, Pundat is configured to listen to a set of BOSSWAVE namespaces. On each of these namespaces, Pundat listens for published messages on the `!meta/archiverequest` key (using the subscription `<namespace/*/!meta/archiverequest`). These messages, which take the form of **AR**s or **Archive Requests** (described below) are by convention *persisted* on URIs. ARs are added/removed/inspected using the `pundat` command-line tool.

### Archive Request Structure

| Field Name | Required? | Data Type | Role |
|------------|-----------|-----------|------|
| ArchiveURI | **yes** | `string` | The URI the archiver subscribes to receive data. This URI can contain wildcards (`+` and `*`) |
| Name | **yes** | `string` | A human-readable name for this stream that serves to disambiguate it from other streams that might be produced from the same URI |
| PO  | **yes** | `string` | Which type of payload the archiver should extract from received messages. If multiple payloads with the PO in the same message, the archiver will operate on each of them |
| Value | **yes** | `string` | The [`OB`](https://github.com/gtfierro/ob) expression used to extract the *numerical* value from the published message. This will be interpreted as a 64-bit float. |
| Time | no | `string` | The [`OB`](https://github.com/gtfierro/ob) expression used to extract the time to be associated with the value. If provided, the archiver uses the `TimeParse` field to determine how to parse the extracted value. If this field is *not* provided, then the archiver just associates the server's current timestamp with the received record |

There are two additional (optional) fields. `URIMatch` is a regular expression executed against each unique URI that pundat sees when subscribing to `ArchiveURI`. Capture groups are supported. `URIReplace`  is a rewrite of the URI that gets used as the stream's name when it is inserted into BTrDB. By default, Pundat will use the full URI of the subscription, which can get unwieldy.

**For published drivers, there is usually an `archive.yml` file already written and it should be a simple matter to edit these for your own deployments.**

### How to attach/remove Archive Requests

First, install `pundat`:

```bash
$ go get -u github.com/gtfierro/pundat
$ go install github.com/gtfierro/pundat
$ pundat
USAGE:
   pundat [global options] command [command options] [arguments...]

COMMANDS:
     ...
     listreq   List all archive requests persisted on the given URI pattern
     rmreq     Remove archive requests specified by file
     addreq    Load archive requests from config file
     nukereq   Remove ALL archive requests attached at the given URI
     ...

GLOBAL OPTIONS:
   --help, -h     show help
   --version, -v  print the version
```

To add/remove archive requests, we use a special YAML file which we will refer to as `archive.yml`. This file contains archive requests and other relevant configuration.

Here is an example `archive.yml` file that contains all of the relevant components. This archive file is for a hypothetical service that publishes data for several sensors on URIs like `scratch.ns/service/s.sensor/<sensorname>/i.board/signal/reading`; we want to extract the "Temperature" and "Occupancy" fields from the published messages for all sensors.

```yaml
# For long URIs, it can be helpful to factor out a long shared prefix to make the rest of the file more readable.
# When interpreted, "Prefix" will be prepended to all URIs mentioned in the file
Prefix: scratch.ns/bms/
  - AttachURI:
    ArchiveURI: s.bms/+/i.xbos.ahu/signal/info
    Value: supply_air_flow_sensor
    Name: supply_air_flow_sensor
    Unit: cfm
    Time: time
    PO: 2.1.1.10/32
    URIMatch: .*/s.bms/(.*)/i.xbos.ahu/.*
    URIReplace: sdh/bms/ahus/supply_air_flow_sensor/$1

  - AttachURI:
    ArchiveURI: s.bms/+/i.xbos.ahu/signal/info
    Value: supply_air_temperature_setpoint
    Name: supply_air_temperature_setpoint
    Unit: F
    Time: time
    PO: 2.1.1.10/32
    URIMatch: .*/s.bms/(.*)/i.xbos.ahu/.*
    URIReplace: sdh/bms/ahus/supply_air_temperature_setpoint/$1
```

Saving this as `sensor_archive.yml`, we can attach the Archive Requests using

```
$ pundat addreq -c sensor_archive.yml
```

and then verify that it was attached by

```
$ pundat listreq scratch.ns/bms/*
RETRIEVING from scratch.ns/bms/*/!meta/archiverequest
┌────────────────
├ ARCHIVE REQUEST
├ PublishedBy: dgKG0DKVUw40PmpY2UqpBDFWdvKD5-KNyXQun2jQkNs=
├ Archiving: scratch.ns/bms/s.bms/+/i.xbos.ahu/signal/info
├ Name: supply_air_temperature
├ Unit: F
├ PO: 2.1.1.10/32
├ UUID: Autogenerating UUIDs
├ Value Expr: supply_air_flow_sensor
├┌
│├ Time Expr: time
│├ Parse Time:
│└
├ URI Match: .*/s.bms/(.*)/i.xbos.ahu/.*
├ URI Replace: scratch.ns/bms/ahus/supply_air_flow_sensor/$1
└────────────────
┌────────────────
├ ARCHIVE REQUEST
├ PublishedBy: dgKG0DKVUw40PmpY2UqpBDFWdvKD5-KNyXQun2jQkNs=
├ Archiving: scratch.ns/bms/s.bms/+/i.xbos.ahu/signal/info
├ Name: supply_air_temperature
├ Unit: F
├ PO: 2.1.1.10/32
├ UUID: Autogenerating UUIDs
├ Value Expr: supply_air_temperature
├┌
│├ Time Expr: time
│├ Parse Time:
│└
├ URI Match: .*/s.bms/(.*)/i.xbos.ahu/.*
├ URI Replace: scratch.ns/bms/ahus/supply_air_temperature/$1
└────────────────
```

To remove requests, use `rmreq` instead of `addreq` when specifying the archive YAML file, or just use the `nukereq` command on a URI to remove all ARs on that URI.

**NOTE: currently the archiver only respects removal of ARs on restart**

## Using

The Pundat commandline tool has a couple utilities you may find helpful for general usage

* `pundat scan`: this locates the base URI of an archiver on a given namespace. This is helpful for liveness checks

    ```
	$ pundat scan ucberkeley
	Found Archiver at:
		 URI        -> ucberkeley
		 Last Alive -> 2018-01-20 18:27:16 +0000 UTC (9.829507254s ago)
	```

* `pundat check` and `pundat grant` verify and grant permission for using the archiver to a BOSSWAVE entity
	```
	$ pundat check -k gabe -u ucberkeley
	Found archiver at: ucberkeley (alive 8.508192267s ago)
	Hash: wTx2G1LVrAo_HVj6jVIFWY7Bl6Q7ge9bDft0Dt5w3UQ=  Permissions: C*    URI: nvrnSE4pJe4ZMO3WQdb-EPi5iwuzmTVUpk6XNNRGYsc=/*/s.giles/!meta/lastalive
	Hash: 908QbAUPnu5rm9h_3L65EQtPOxPVPvKibt2KpZxG_CQ=  Permissions: P     URI: nvrnSE4pJe4ZMO3WQdb-EPi5iwuzmTVUpk6XNNRGYsc=/s.giles/_/i.archiver/slot/query
	Hash: _s9XHmbnqk8RrEORpG84jW2qnAdc-6iP15esIP4rymI=  Permissions: C     URI: nvrnSE4pJe4ZMO3WQdb-EPi5iwuzmTVUpk6XNNRGYsc=/s.giles/_/i.archiver/signal/T8wqsqNgD_NmBeDp1n7Kx1b5yfXDWo8Oqb3y0AQ8-y0,queries
	Key dgKG0DKVUw40PmpY2UqpBDFWdvKD5-KNyXQun2jQkNs= has access to archiver at ucberkeley
	```
* `pundat range` checks which ranges of data a BOSSWAVE entity can see
