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

`$PUNDAT_ENTITY` also needs permission to operate on a namespace (`$GILES_BW_NAMESPACE). The DoT to grant is

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

## Archive Requests

A **stream** is the unit of archival and data access. A stream consists of:
* a timeseries (a single progression of `<time, value>` pairs)
* metadata (a bag of `key = value` pairs)
* a UUID (a unique 16-byte identifier)

In BOSSWAVE, drivers simply push their data into the overlay network where anyone with permission can listen to the data. In order to archive data in BOSSWAVE, instead of explicitly instructing a driver to push data to a particular archiver (which would require prior knowledge of an archiver), we instead tell the archiver to listen to URIs on which drivers or services publish data.

Upon startup, Pundat is configured to listen to a set of BOSSWAVE namespaces. On each of these namespaces, Pundat listens for published messages on the `!meta/archiverequest` key (using the subscription `<namespace/*/!meta/archiverequest`). These messages, which take the form of **AR**s or **Archive Requests** (described below) are by convention *persisted* on URIs. ARs are added/removed/inspected using the `pundat` command-line tool.

### What's In an **Archive Request**

| Field Name | Required? | Data Type | Role |
|------------|-----------|-----------|------|
| URI | **yes** | `string` | The URI the archiver subscribes to receive data. This URI can contain wildcards (`+` and `*`) |
| Name | **yes** | `string` | A human-readable name for this stream that serves to disambiguate it from other streams that might be produced from the same URI |
| PO  | **yes** | `string` | Which type of payload the archiver should extract from received messages. If multiple payloads with the PO in the same message, the archiver will operate on each of them |
| UUIDExpr | no | `string` | The [`OB`](https://github.com/gtfierro/ob) expression used to extract the UUID from the message. If not specified, the archiver deterministically generates a UUIDv3 in the `b26d2e62-333e-11e6-b557-0cc47a0f7eea` namespace using the concatenation of the `URI`,`PO` and `Name` fields in the Archive Request. |
| ValueExpr | **yes** | `string` | The [`OB`](https://github.com/gtfierro/ob) expression used to extract the *numerical* value from the published message. This will be interpreted as a 64-bit float. |
| TimeExpr | no | `string` | The [`OB`](https://github.com/gtfierro/ob) expression used to extract the time to be associated with the value. If provided, the archiver uses the `TimeParse` field to determine how to parse the extracted value. If this field is *not* provided, then the archiver just associates the server's current timestamp with the received record |
| TimeParse | no | `string` | A [https://golang.org/pkg/time/#Parse](https://golang.org/pkg/time/#Parse) string to decode the timestamp found by the `TimeExpr` field |
| InheritMetadata | no | `bool` | This field is true by default. If true, then the metadata associated with the stream produced by the Archive Request is inherited from each of the prefix URIs of the archive URI. For example, if the archive URI is `/a/b/c`, then metadata will be inherited from `/a/!meta/+`, `/a/b/!meta/+` and `/a/b/c/!meta/+`. If false, then the stream will have no metadata associated with it |

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
Prefix: scratch.ns/service
# list of Archive Requests to be attached
Archive:
   - AttachURI: s.sensor # where to place the AR message
     ArchiveURI: s.sensor/+/i.board/signal/reading # the actual URI argument to the AR
     Value: temperature # here and below are all AR fields
     Name: temperature
     PO: 2.0.0.0
     InheritMetadata: true
   - AttachURI: s.sensor
     ArchiveURI: s.sensor/+/i.board/signal/reading
     Value: occupancy
     Name: occupancy
     PO: 2.0.0.0
     InheritMetadata: true
```

Saving this as `sensor_archive.yml`, we can attach the Archive Requests using 

```
$ pundat addreq -c sensor_archive.yml
```

and then verify that it was attached by

```
$ pundat listreq scratch.ns/service/*
RETRIEVING from scratch.ns/service/*/!meta/archiverequest
---------------
PublishedBy: dgKG0DKVUw40PmpY2UqpBDFWdvKD5-KNyXQun2jQkNs=
Archiving: scratch.ns/service/s.sensor/+/i.board/signal/reading
Name: temperature
Extracting PO: 2.0.0.0
Autogenerating UUIDs
Value Expr: temperature
Using server timestamps
Metadata:
Inheriting metadata from URI prefixes
---------------
PublishedBy: dgKG0DKVUw40PmpY2UqpBDFWdvKD5-KNyXQun2jQkNs=
Archiving: scratch.ns/service/s.sensor/+/i.board/signal/reading
Name: occupancy
Extracting PO: 2.0.0.0
Autogenerating UUIDs
Value Expr: occupancy
Using server timestamps
Metadata:
Inheriting metadata from URI prefixes
```

To remove requests, use `rmreq` instead of `addreq` when specifying the archive YAML file, or just use the `nukereq` command on a URI to remove all ARs on that URI.

**NOTE: currently the archiver only respects removal of ARs on restart**

### More Advanced Example: Anemometer

Some anemometer data is published on URIs  like:

```
ucberkeley/anemometer/data/+/+/s.anemometer/+/i.anemometerdata/signal/feed
```

where each message follows the following structure with PO 2.0.11.1:

```go
type OutputData struct {
	// The time, in nanoseconds since the epoch, that this set of measurements was taken
	Timestamp int64 `msgpack:"time"`
	// The symbol name of the sensor (like a variable name, no spaces etc)
	Sensor string `msgpack:"sensor"`
	// The name of the vendor (you) that wrote the data processing algorithm, also variable characters only
	// This gets set to the value passed to RunDPA automatically
	Vendor string `msgpack:"vendor"`
	// The symbol name of the algorithm, including version, parameters. also variable characters only
	// This gets set to the value passed to RunDPA automatically
	Algorithm string `msgpack:"algorithm"`
	// The set of time of flights in this output data set
	Tofs []TOFMeasure `msgpack:"tofs"`
	// The set of velocities in this output data set
	Velocities []VelocityMeasure `msgpack:"velocities"`
	// Any extra string messages (like X is malfunctioning), these are displayed in the log on the UI
	Extradata []string `msgpack:"extradata"`	
	//Uncorrectable link errors
	Uncorrectable int `msgpack:"uncorrectable"`
	//Correctable link errors
	Correctable   int `msgpack:"correctable"`
	//Total datagrams
	Total         int `msgpack:"total"`
}

// TOFMeasure is a single time of flight measurement. The time of the measurement
// is inherited from the OutputData that contains it
type TOFMeasure struct {
	// SRC is the index [0,4) of the ASIC that emitted the chirp
	Src int `msgpack:"src"`
	// DST is the index [0,4) of the ASIC that the TOF was read from
	Dst int `msgpack:"dst"`
	// Val is the time of flight, in microseconds
	Val float64 `msgpack:"val"`
}

type VelocityMeasure struct {
	//Velocity in m/s
	X float64 `msgpack:"x"`
	Y float64 `msgpack:"y"`
	//Z is the vertical dimension
	Z float64 `msgpack:"z"`
}
```

We want the archiver to track the velocity measurements; we need 3 Archive Requests to do this: one each for X, Y and Z values.

Our `archive.yml` file is as follows:

```yaml
Prefix: ucberkeley/anemometer
Archive:
    - AttachURI: data
      ArchiveURI: data/+/+/s.anemometer/+/i.anemometerdata/signal/feed
      Value: velocities[:].x
      Name: velocityX
      PO: 2.0.11.1
      InheritMetadata: true
    - AttachURI: data
      ArchiveURI: data/+/+/s.anemometer/+/i.anemometerdata/signal/feed
      Value: velocities[:].y
      Name: velocityY
      PO: 2.0.11.1
      InheritMetadata: true
    - AttachURI: data
      ArchiveURI: data/+/+/s.anemometer/+/i.anemometerdata/signal/feed
      Value: velocities[:].z
      Name: velocityZ
      PO: 2.0.11.1
      InheritMetadata: true
```
