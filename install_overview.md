# XBOS Installation Overview

XBOS follows a "microservice" architecture; that is, an instance of XBOS is composed of a set of distributed services connected by a secure bus (BOSSWAVE).
As such, there are several ways to arrange these services. In this guide, we will cover one common architectural configuration.

In this configuration, there is a local on-premesis server and a set of remote services.

## Local Server

The local XBOS server has the following

- **BOSSWAVE Agent**: a gateway to the global, secure pubsub communication plane
- **configuration**: a git repo containing driver and service configurations. This repo is not necessarily pushed to a remote server
- **Spawnpoint**: a local Spawnpoint daemon for running drivers requiring access to the local network
- **watchdogs**: a set of monitors for local processes to help determine the health of the deployment

Installation instructions for the local server are located [here](https://docs.xbos.io/local_install.html)

## Core Services

There are several core services important for a full XBOS installation. Due to the immense variation in required resources, it may not make sense to install all of these services on the local server.

### Archiver Service

The archiver service is usually executed on a larger cluster running [BTrDB](https://docs.smartgrid.store/).
The XBOS development team runs a development archiver server. Contact Gabe Fierro (gtfierro AT cs DOT berkeley DOT edu) for more information.

- [BTrDB installation](https://docs.smartgrid.store/)
- [Pundat installation](https://github.com/gtfierro/PunDat/wiki)

### Building Profile Service

[HodDB](http://hoddb.org/) is an implementation of a Building Profile service for XBOS.
It requires a [Brick](https://brickschema.org/) model of a building to operate. Sample Brick models can be found [here](https://github.com/SoftwareDefinedBuildings/BrickModels) and [here](https://brickschema.org/download/)

- [HodDB installation](http://hoddb.org/installation/)

### Schedulers

More formal definitions of schedulers are coming soon. In the meantime, we offer a sample scheduler example

- [simple thermsotat schedule](https://github.com/SoftwareDefinedBuildings/XBOS/tree/master/apps/sample_schedule)
