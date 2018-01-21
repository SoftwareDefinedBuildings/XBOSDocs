# HodDB

[HodDB](https://hoddb.org) is a query processor and database for [Brick models](https://brickschema.org).

## Configuration

### BOSSWAVE Entity

HodD optionally exposes an API over BOSSWAVE, requiring an entity (`$HODDB_ENTITY`) with publich/subscribe capabilities on a namespace.
Create the entity and place it in a known location that you don't mind being mounted into a docker container (such as `/etc/hod`).

The permissions MDAL needs are all permissions on some prefix ending in `s.hod`, e.g.

```bash
bw2 mkdot -f $PRIVILEGED_ENTITY             \
          -t $HODDB_ENTITY                  \
          -u $NAMESPACE/services/s.hod/*   \
          -x PC*                            \
          -m 'HodDB operation'
```

The URI argument here (minus `s.hod`, i.e. `$NAMESPACE/services`) should be included in the configuration for the HodDB service

### Config File

HodDB configuration is documented on the [HodDB site](https://hoddb.org/configuration). it is replicated here

HodDB is configured with a YAML file. By default, this file is called `hodconfig.yml` and is loaded from the directory HodDB is executed from, though this can be changed with the `--config/-c` command line option when executing the `hod` binary. All paths below are relative to the location from which hod is executed.

Configuration defaults are as follows; there's usually no reason to change these aside from the list of buildings to load and the network and BOSSWAVE configuration.
Default options are commented out

```yaml
######## HodDB Configuration
####
# Location and structure of database
####
# how we load data into the database.
# The keys here are the names of the graphs and how they are referred to when
# querying. The values are file paths to the source for each graph
# CHANGE THIS!
Buildings:
    ciee: buildings/ciee.ttl
    sdh: buildings/sdh.ttl
    soda: buildings/soda.ttl
# the location of the database files
# DBPath: _hoddb
# the path to the TTL file containing Brick relationships
# BrickFrameTTL: "$GOPATH/src/github.com/gtfierro/hod/BrickFrame.ttl"
# the path to the TTL file containing Brick classes
#BrickClassTTL: "$GOPATH/src/github.com/gtfierro/hod/Brick.ttl"

####
# Interface Enabling
####
# Enable HTTP server
EnableHTTP: true
# Enable BOSSWAVE server
EnableBOSSWAVE: true

####
# HTTP Server Configuration
####
# port to run the server on
#ServerPort: 47808
# Whether or not to serve on IPv6
#UseIPv6: false
# Whether or not to serve on localhost. If false, serves on a public interface
#ListenAddress: 0.0.0.0
# Path to the server directory of hod, which contains the necessary HTML files
#StaticPath: $GOPATH/src/github.com/gtfierro/hod/server
# If specified, serve the frontend over HTTPS using golang.org/x/crypto/acme/autocert
# If left blank (default), just serve over HTTP
#TLSHost: ""

####
# BOSSWAVE Server Configuration
####

# BOSSWAVE agent
#BW2_AGENT: 172.17.0.1:28589
# BOSSWAVE entity. CHANGE THIS!
BW2_DEFAULT_ENTITY: path/to/entity/file
# Base URI. CHANGE THIS!
HodURI: scratch.ns/hod

####
# configuration for verbosity during operation
####
# Show the namespace prefixes
#ShowNamespaces: false
# Show the built dependency graph of query terms
#ShowDependencyGraph: false
# Show the set of operations in the query plan
#ShowQueryPlan: false
# Show the latencies of creating the query plan
#ShowQueryPlanLatencies: false
# Show the latencies of each operation in the query plan
#ShowOperationLatencies: false
# Show the full latency of the query (and its larger components)
#ShowQueryLatencies: false
# Set log level. In order of increasing verbosity:
# Debug, Info, Notice, Warning, Error, Critical
#LogLevel: Error
```

#### Example

Here is a brief example of how to set up the configuration.

The directory 'sample' has the `hodconfig.yaml` file above. We create a folder called `buildings` to store our 3 TTL files representing 3 Brick models. This is indicted to HodDB
in the `Buildings` configuration option above.

```bash
$ tree
.
├── buildings
│   ├── ciee.ttl
│   ├── sdh.ttl
│   └── soda.ttl
└── hodconfig.yaml
```

We can then execute HodDB against this configuration with

```bash
$ docker run -d --name hod -v `pwd`/sample:/etc/hod -p 47808:47808 gtfierro/hod:latest
```

## Installation

HodDB is shipped as a Docker container image `gtfierro/hod:latest` (most recent version is `gtfierro/hod:0.5.6`.
You can build this container yourself by running `make container` in a cloned copy of the [HodDB repository](https://github.com/gtfierro/hod).

### Run with Kubernetes

If you are running Kubernetes on your node/cluster, then you can easily install HodDB by using its Kubernetes file.

Keep in mind that HodDB currently requires a volume mount where the `mdal.yaml` configuration file is stored.
```yaml
# snippet of HodDB kubernetes file
...
  spec:
      containers:
          - name: hod
            image:  gtfierro/hod:0.5.6
            imagePullPolicy: Always
            ports:
              - containerPort: 47808
            volumeMounts:
              - name: hodconfig
                mountPath: /etc/hod
      volumes:
          - name: hodconfig
            hostPath:
              path: << config directory >> # <-- create this host folder and place all HodDB config there
                                           #     including the building models and hodconfig.yaml file
```

To execute HodDB as a Kubernetes service, use the following:

```bash
curl -O https://github.com/gtfierro/hod/blob/master/kubernetes/deployhod.yaml
# edit deployhod.yaml and setup HodDB config directory as specified above
kubectl create -f deployhod.yaml
```


### Run with Docker

If you are not running Kubernetes, you can invoke the MDAL container directly

```bash
$ docker run -d --name hod -v /path/to/config/dir:/etc/hod -p 47808:47808 gtfierro/hod:latest
```

## Using

The [HodDB site](https://hoddb.org) has several guides on how to use HodDB and Brick:
- [Making Brick models](https://hoddb.org/making)
- [Brick query language](https://hoddb.org/query)

### HTTP Interface

HodDB has a convenient user interface for running, building and visualizing queries. By default this interface is available on port 47808.

### Access Control

The HodDB commandline tool has a couple utilities for granting access to a HodDB database as well as granting access to a Brick model.

For access control to a HodDB instance, use the `hod check` and `hod grant` commands:

```bash
NAME:
   hod check - Check access to HodDB on behalf of some key

USAGE:
   hod check [command options] [arguments...]

OPTIONS:
   --agent value, -a value   Local BOSSWAVE Agent (default: "127.0.0.1:28589") [$BW2_AGENT]
   --entity value, -e value  The entity to use [$BW2_DEFAULT_ENTITY]
   --key value, -k value     The key or alias to check
   --uri value, -u value     The base URI of HodDB
```

```bash
NAME:
   hod grant - Grant access to HodDB to some key

USAGE:
   hod grant [command options] [arguments...]

OPTIONS:
   --agent value, -a value     Local BOSSWAVE Agent (default: "127.0.0.1:28589") [$BW2_AGENT]
   --entity value, -e value    The entity to use [$BW2_DEFAULT_ENTITY]
   --bankroll value, -b value  The entity to use for bankrolling [$BW2_DEFAULT_BANKROLL]
   --expiry value              Set the expiry on access to HodDB measured from now e.g. 3d7h20m
   --key value, -k value       The key or alias to check
   --uri value, -u value       The base URI of HodDB
```

**Note:** There is currently no access control on the HTTP interface.

**TODO: document capability URIs for Brick model access**
