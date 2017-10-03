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
