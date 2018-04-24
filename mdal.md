# Metadata-driven Data Access Layer

[MDAL](https://github.com/gtfierro/mdal) retrieves, aggregates and formats timeseries data from BTrDB using queries that reference a Brick model.
MDAL should be run on the same cluster or node as your BTrDB installation

To query a Brick model, MDAL can either create an embedded HodDB instance or access a remote one

## Configuration


### BOSSWAVE Entity

MDAL exposes an API over BOSSWAVE, so it needs to be configured with a BOSSWAVE entity (`$MDAL_ENTITY`) with publish/subscribe capabilities on a namespace.
Create the entity and place it in a known location that you don't mind being mounted into a docker container (such as `/etc/mdal`).

The permissions MDAL needs are all permissions on some prefix ending in `s.mdal`, e.g.

```bash
bw2 mkdot -f $PRIVILEGED_ENTITY             \
          -t $MDAL_ENTITY                   \
          -u $NAMESPACE/services/s.mdal/*   \
          -x PC*                            \
          -m 'MDAL operation'
```

The URI argument here (minus `s.mdal`, i.e. `$NAMESPACE/services`) should be included in the configuration for the MDAL service

### Config File

MDAL uses a simple YAML config file canonically called `mdal.yaml`

```yaml
# this is the reachable address:port (or hostname:port) of the BTrDB instance MDAL uses
BTrDBAddress: "localhost:4410"
# this is the base URI of the MDAL service. $NAMESPACE should be replaced with the extra
Namespace: $NAMESPACE/services
# this is the path to the BOSSWAVE entity MDAL uses. This will likely be a volume mount path
# inside a container
BW2_DEFAULT_ENTITY: path/to/$MDAL_ENTITY
# This is the address of the BOSSWAVE agent MDAL uses. 172.17.0.1:28589 is the default
BW2_AGENT: 172.17.0.1:28589

# if true, then the HTTP interface is enabled
HTTPEnabled: true
# the port used by the HTTP interface
Port: 8989
# the address MDAL listens on
ListenAddress: 127.0.0.1
# if true, binds to an IPv6 address
UseIPv6: false
# if specified, MDAL uses port 443 and uses a LetsEncrypt certificate using this hostname
TLSHost:

# If true, MDAL runs a local copy of HodDB with the given configuration file.
# If using this option, make sure that the Brick model files mentioned in the HodDB configuration
# are also mounted into the container (or otherwise reachable by MDAL)
EmbeddedBrick: false
# the configuration file used by MDAL if using an embedded HodDB instance
HodConfig: hodconfig/hodconfig.yaml

# If true, MDAL uses a hosted Brick model by instantiating a HodDB client accessing a HodDB
# instance hosted on BOSSWAVE at the given URI. See the HodDB documentation for how to check/grant
# $MDAL_ENTITY access to an instance of HodDB
RemoteBrick: true
BaseURI: xbos/hod
```

## Installation

MDAL is shipped as a Docker container image `gtfierro/mdal:latest` (most recent version is `gtfierro/mdal:0.0.2`.
You can build this container yourself by running `make container` in a cloned copy of the [MDAL repository](https://github.com/gtfierro/mdal).

### Run with Kubernetes

If you are running Kubernetes on your node/cluster, then you can easily install MDAL by using its Kubernetes file.

Keep in mind that MDAL currently requires a volume mount where the `mdal.yaml` configuration file is stored.
```yaml
# snippet of MDAL kubernetes file
...
    spec:
        containers:
            - name: mdal
              image:  gtfierro/mdal:0.0.2
              imagePullPolicy: Always
              volumeMounts:
                - name: mdal
                  mountPath: /etc/mdal  # <-- this is how your host folder gets mounted in the container.
        volumes:
            - name: mdal
              hostPath:
                path: /etc/mdal   # <-- create this host folder and place the mdal.yaml config file there
```

To execute MDAL as a Kubernetes service, use the following:

```bash
curl -O https://github.com/gtfierro/mdal/blob/master/kubernetes/k8mdal.yaml
# edit /etc/mdal/mdal.yaml and k8mdal.yaml appropriately
kubectl create -f k8mdal.yaml
```


### Run with Docker

If you are not running Kubernetes, you can invoke the MDAL container directly

```bash
docker run -d --name mdal -v /etc/mdal:/etc/mdal gtfierro/mdal:latest
```

Don't forget to forward the HTTP port if that interface is enabled

## Using

### Permissions

`mdal check` and `mdal grant` verify and grant permission to use the MDAL service at a given URI to a BOSSWAVE entity

```
$ mdal check -k T8wqsqNgD_NmBeDp1n7Kx1b5yfXDWo8Oqb3y0AQ8-y0= -u xbos/mdal
MDAL: Commit: 8284e13 Release: 0.0.3
T8wqsqNgD_NmBeDp1n7Kx1b5yfXDWo8Oqb3y0AQ8-y0=
Hash: 8z50T3ZQCMvpRH059d-DeZmCnuH9QKOkGsRU-Zz4rdc=  Permissions: C*    URI: 06DZ14k6dhRognGUoSHofD8oS8CUaWwq4tH-FPW13UU=/mdal/*/s.mdal/!meta/lastalive
Hash: 4e0ZrYpg2B-7oy_KGpxjxdnYPspKSFb_pr4yccJ-TdQ=  Permissions: P     URI: 06DZ14k6dhRognGUoSHofD8oS8CUaWwq4tH-FPW13UU=/mdal/s.mdal/_/i.mdal/slot/query
Hash: dKCtE_OY0QBm3Zq8eKxauaUy7GN1maeiMHL9Zb5eJ1E=  Permissions: C     URI: 06DZ14k6dhRognGUoSHofD8oS8CUaWwq4tH-FPW13UU=/mdal/s.mdal/_/i.mdal/signal/T8wqsqNgD_NmBeDp1n7Kx1b5yfXDWo8Oqb3y0AQ8-y0
Key T8wqsqNgD_NmBeDp1n7Kx1b5yfXDWo8Oqb3y0AQ8-y0= has access to archiver at xbos/mdal

```

### API

Requests are msgpack-serialized and look like:

```python
query = {
    "Composition": ["temp"],
    "Selectors": [MEAN],
    "Variables": [
        {"Name": "meter",
         "Definition": """SELECT ?meter_uuid WHERE {
                        ?meter rdf:type/rdfs:subClassOf* brick:Electric_Meter .
                        ?meter bf:uuid ?meter_uuid .
                        };""",
         "Units": "kW",
        },
        {"Name": "temp",
         "Definition": """SELECT ?temp_uuid WHERE {
                        ?temp rdf:type/rdfs:subClassOf* brick:Temperature_Sensor .
                        ?temp bf:uuid ?temp_uuid .
                        };""",
         "Units": "C",
        },
    ],
    "Time": {
        "T0": "2017-07-21 00:00:00",
        "T1": "2017-08-30 00:00:00",
        "WindowSize": '2h',
        "Aligned": True,
    },
}
```

- `Composition`: the order of variables and UUIDs to be included in the response matrix. Variables are defined in `Variables` key (below) and resolve to a set of UUIDs. UUIDs are the pointers used by the timeseries database and represent a single timeseries sequence. If you want to apply unit conversion to the UUIDs, you will need to have instead define the UUIDs using a variable definition below.
- `Selectors`: for each timeseries stream, we can get the raw data, or we can get resampled min, mean and/or max (as well as bucket count). Each item in the `Composition` list has a corresponding selector. This is a set of flags:
	- `MEAN`: selects the mean stream
	- `MAX`: selects the max stream
	- `MIN`: selects the min stream
	- `COUNT`: selects the count stream (how many readings in each resampled bucket)
	- `RAW`: selects the raw data. This cannot be resampled and is mutually exclusive with
	  the above flags
	Combine flags like `MEAN|MAX`
- `Variables`: each variable mentioned in `Composition` has a definition here. Each variable needs the following fields:
    - `Name`: the name of the variable. Refer to the variable in `Composition` using this name
    - `Definition`: the Brick query that will be resolved to a set of UUIDs. The returned variables need to end in `_uuid`
    - `UUIDS`: a list of additional UUIDs to append to this variable definition (can be used in addition or instead of the Brick query above). To perform unit conversion on data for these UUIDs, put those UUIDs here.
    - `Units`: the desired units for the stream; MDAL will perform the unit conversion if possible
- `Time`: the temporal parameters of the data query
    - `T0`: the first half of the range (inclusive)
    - `T1`: the second half of the range (inclusive). These will be reordered appropriately by MDAL
    - `WindowSize`: window size as a Go-style duration, e.g. "5m", "1h", "3d".
        - Supported units are: `d`,`h`,`m`,`s`,`us`,`ms`,`ns`
    - `Aligned`: if true, then all timesetamps will be the same, else each stream (UUID) will have its own timestamps. Its best to leave this as `True`
- `Params`: don't touch this for now

Supported unit conversions (case insensitive):
- `w/watt`, `kw/kilowatt`
- `wh/watthour`, `kwh`,`kilowatthour`
- `c/celsius`,`f/fahrenheit`,`k/kelvin`

### Python Client

```python
from xbos.services import mdal
client = mdal.MDALClient("xbos/mdal")
query = {
    "Composition": ["temp"],
    "Selectors": [mdal.MEAN],
    "Variables": [
        {"Name": "temp",
         "Definition": "SELECT ?temp_uuid WHERE { ?temp rdf:type/rdfs:subClassOf* brick:Temperature_Sensor . ?temp bf:uuid ?temp_uuid . };",
         "Units": "C",
        },
    ],
    "Time": {
        "T0": "2017-07-21 00:00:00 PST",
        "T1": "2017-08-21 00:00:00 PST",
        "WindowSize": '30m',
        "Aligned": True,
    },
}
resp = client.do_query(query,timeout=300)
print resp.get('error') # see if there's an error
df = resp['df']
print df.describe()
```
