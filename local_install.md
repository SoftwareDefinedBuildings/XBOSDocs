# Local Server Installation

The local server installation script handles the following:

- BOSSWAVE agent installation
- default entity and bankroll creation (bankroll requires external action)
- namespace configuration
- designated router authorization (requires external action)
- spawnpoint entity and spawnd installation, configuration
- watchdog installation:
    - wdtop
    - sdmon

## Ubuntu Install

For the XBOS server, we recommend installing a recent version of [Ubuntu Server](https://www.ubuntu.com/download/server). You can use a standard installation procedure here. We use the following defaults (when prompted during the installation):

- Partitioning: use guided partition on the full disk (no need to configure LVM)
- Updates: No automatic updates
- Software Selection: add OpenSSH server in addition to standard system utilities

## Configuration

The configuration file `config.sh` must be filled out before the installation script is run.
The local server installation script comes with a configuration file, which determines which steps run as well as establishes configuration parameters.

The segments of installation are explained below, and are marked as for a "personal install" (a computer not used as an XBOS server), a "server install", or both.


Download the template [config file](https://raw.githubusercontent.com/SoftwareDefinedBuildings/XBOS/master/commissioning/config.sh)


```bash
curl -O https://raw.githubusercontent.com/SoftwareDefinedBuildings/XBOS/master/commissioning/config.sh
```

Edit this file according to the below specifications.

### BOSSWAVE Install

* for personal install
* for server install

You will configure the following in `config.sh`:

```bash
# name + email address to be attached to configured BOSSWAVE objects
# if this contains spaces, make sure to use quotes
BW2_DEFAULT_CONTACT=

# path to entity to use as an administrative entity for configuring/interacting with services
# Leave blank to have the installer configure this
BW2_DEFAULT_ENTITY=

# path to entity to use for bankrolling BOSSWAVE operations
# Leave blank to have the installer configure this (it will default to $BW2_DEFAULT_ENTITY)
BW2_DEFAULT_BANKROLL=

# name to use for git commits to config repo
GIT_USER=
# email to use for git commits to config repo
GIT_EMAIL=
```

The XBOS installer runs the standard `curl get.bw2.io/agent | bash` installation.

**Interactive note**: if your default entity does not have any Ether funds, the installer will pause and ask if you want to continue. The installer will output the BOSSWAVE address representing your public "bank account", so it is simple to ask someone for funds.

### Tool installs

* for personal install
* for server install

Several supplementary tools are helpful for interacting with an XBOS deployment.

The XBOS installer can:

- install the Go programming language (1.9)
    - configure:
        ```bash
        INSTALL_GO=true
        ```

- install the `spawnctl` tool for administrating and monitoring spawnpoint deployments:
    - configure:
        ```bash
        # Requires Go
        INSTALL_SPAWNPOINT_CLIENT=true
        ```
    - [documentation](https://github.com/SoftwareDefinedBuildings/spawnpoint#interacting-with-spawnpoints-using-spawnctl)

- install the `pundat` tool for configuring the data archiver
    - configure:
        ```bash
        # Requires Go
        INSTALL_PUNDAT_CLIENT=true
        ```
    - [documentation](https://github.com/gtfierro/PunDat/wiki)

### Namespace Configuration

* for server install

In XBOS, we strucutre the set of resources for a deployment site around a central namespace.
A namespace is defined by a public/private key pair (VK/SK in BOSSWAVE parlance), and is referred to by an alias (a human-readable immutable alias of the public key).
Additionally, a namespace must have a contract with a server for that server to be authorized to carry traffic for the namespace; this is how we configure a broker for the namespace.

The XBOS installer requires the following configuration

```bash
# set to false to ignore configuration for namespace
CONFIGURE_NAMESPACE=true

# path to entity to use as namespace authority.
# Leave blank to have the installer configure this
NAMESPACE_ENTITY=

# alias to use for the namespace.
# Leave blank to not configure an alias (or use the existing one for your provided NAMESPACE_ENTITY)
NAMESPACE_ALIAS=

# the VK of the designated router (DR) that  will carry traffic for this namespace
# it is helpful to have the DR ready to make an offer. This will likely be given to you.
DESIGNATED_ROUTER_VK=
```

### Spawnpoint Configuration

* for server install

The XBOS installer invokes the [automated spawnpoint installer](https://github.com/SoftwareDefinedBuildings/spawnpoint/tree/master/installer).
This will configure an entity and spawnd service for a server.

The XBOS installer requires the following configuration:

```bash
# if true, install spawnd server
INSTALL_SPAWNPOINT_SERVER=true
# entity to run the spawnd daemon.
# Leave blank to have the installer configure this
SPAWND_ENTITY=
# Spawnpoint system config
SPAWND_MEM_ALLOC="4G"
SPAWND_CPU_SHARES=2048
```

### Watchdog Configuration

* for server install

[Watchdogs](https://github.com/immesys/wd) are a convenient way to track the health of deployed servers and services.
The provided watchdogs monitor CPU, memory, disk space and uptime of core local services such as the BOSSWAVE agent and spawnd daemon.

The XBOS installer requires the following configuration:

```bash
# if true, install watchdog services (requires systemd)
INSTALL_WATCHDOGS=true
# need to provide a WD_TOKEN in order to configure watchdog services.
# This will be given to you
WD_TOKEN=
# need to provide the prefix for watchdog names.
# This will be given to you
WD_PREFIX=
```

## Installation

Use the following [installation script](https://raw.githubusercontent.com/SoftwareDefinedBuildings/XBOS/master/commissioning/install.sh)

```bash
curl -O https://raw.githubusercontent.com/SoftwareDefinedBuildings/XBOS/master/commissioning/install.sh
byobu new-session
./install.sh
```

Step-by-step instructions coming soon!
