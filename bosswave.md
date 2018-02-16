# BOSSWAVE Overview

This guide is adapted from [https://github.com/immesys/bw2#getting-started](https://github.com/immesys/bw2#getting-started)




## Terminology

**entity**: the principal in the system; a verifying/signing (public/private) key pair

```
┳ Type: Entity key file
┣┳ Entity VK=jMYG9Oj0bqbmITTSqdACFBztgNcVR2oE1w4tglmQyGQ=
┃┣ Signature: valid
┃┣ Registry: UNKNOWN
┃┣ Keypair: ok
┃┣ Balances:
┃┃┣  0 (0x801c65f2e06c72326a383da70e266271befced2a) 0.000000 Ξ
┃┃┣  1 (0x9ccd2a8b1f9c64c3fa46cb08c4013c69d04097aa) 0.000000 Ξ
┃┃┣  2 (0x0d3e4927ab9922102de34d3a80f16732f9fd54d5) 0.000000 Ξ
┃┃┣  3 (0x2dc672b035fe78d68c883710a6b1c6407e122775) 0.000000 Ξ
┃┃┣  4 (0x11d18aae1491e5b9966d2eff5b48c40d9133018e) 0.000000 Ξ
┃┃┣  5 (0xd9329448391a5060a42584df484062ea56c40adc) 0.000000 Ξ
┃┃┣  6 (0xe10de834ba801e67afc87e4887534849229a4d39) 0.000000 Ξ
┃┃┣  7 (0xe295064d24fd67718495ee67dbacd36588e2d43d) 0.000000 Ξ
┃┃┣  8 (0x7a001bfece365cd822ecf3af75fe8d2a14de4ff9) 0.000000 Ξ
┃┃┣  9 (0xe3d1e1ad516cf5b32598518cf5d5c0ac7cdc9d4d) 0.000000 Ξ
┃┃┣ 10 (0x91f2620f56a1dc1d6e0ba43faa652588aa7db249) 0.000000 Ξ
┃┃┣ 11 (0x8e660a6b238e9b314adbcf5aaf98a5bc15e1f06b) 0.000000 Ξ
┃┃┣ 12 (0x2202c20c75bf98c7fe6c3676a85420b5c25cfad4) 0.000000 Ξ
┃┃┣ 13 (0xfc7565d1505b41a93c88dd08f7a1dfd67f8c73e5) 0.000000 Ξ
┃┃┣ 14 (0x8f8208cb48070244bf7b34bd11cb92f48d317c17) 0.000000 Ξ
┃┃┣ 15 (0xfe4d5e616da0f98a4407f186ac82b6661753f2fc) 0.000000 Ξ
┃┣ Created: 2016-04-04T19:58:17-07:00
┃┣ Expires: 2016-05-04T19:58:17-07:00
```

---


**URI**: a hierarchical string starting with a verifying key. Hierarchies are delineated with the `/` character.

```
~~~~~~~~~~~~~~~~~~~ VK ~~~~~~~~~~~~~~~~~~~~~
gvnMwdNvhD5ClAuF8SQzrp-Ywcjx9c1m4du9N5MRCXs=/devices/enlighted/s.enlighted/Sensor01934e/i.xbos.meter/signal/info
```

---

**namespace**: a verifying key that is being used as the initial part of the URI. For routable namespaces, the verifying key identities which server to use as a message broker. Namespaces do not need to be routable. Non-routable namespaces can be considered to represent hierarchical permissions.

---

**DoT**: a Declaration of Trust is a signed statement granting permissions on a URI from one entity to another. A DoT has an expiry and can be revoked.

```
┳ Type: Access DOT
┣┳ DOT cZ27izQDaIkWGwet3g0SJToopSfiNzlM63S2cTLj2Ts=
┃┣ Signature: valid
┃┣ Registry: valid
┃┣ From:
┃┣┳ Entity VK: rMvgqnEuhuCFU_HsNRMGWcq7vY0_cUqctijQuvb055s=
┃┃┣ Signature: valid
┃┃┣ Registry: valid
┃┃┣ Alias: gabe.ns
┃┃┣ Contact: Gabe Fierro <gtfierro@eecs.berkeley.edu>
┃┃┣ Comment: Gabe Laptop
┃┃┣ Created: 2016-05-13T16:35:30-07:00
┃┃┣ Expires: 2026-05-11T16:35:30-07:00
┃┣ To:
┃┣┳ UNKNOWN ENTITY, VK=X_3qDxKT9JOmpFzPy0o-Xu7JGdH1kiYYXBlYHc0p3Gk=
┃┣ URI: rMvgqnEuhuCFU_HsNRMGWcq7vY0_cUqctijQuvb055s=/s.giles/0/i.archiver/slot/query
┃┣ Permissions: P
┃┣ Created: 2016-07-02T23:57:50-07:00
┃┣ Expires: 2016-09-30T23:57:50-07:00
┃┣ TTL: 0
```


---

**designated router**: the pub-sub broker responsible for routing messages on behalf of a namespace. Designated routers are bound to one or more namespaces by invoking one of the BOSSWAVE smart contracts. Designated routers also store persisted messages.

## Installing BOSSWAVE

The directions below all assume that BOSSWAVE is installed on your computer. If you are running Ubuntu and/or Mac OS X, you can install the "base" BOSSWAVE by running

```bash
curl get.bw2.io/agent | sudo bash
```

but the full quickstart below may be more helpful.

### Quickstart

The above configuration/installation can be performed with a convenient script.

Download and fill out the [configuration script](https://docs.xbos.io/local_install.html#configuration) and fill out the following fields:

- `BW2_DEFAULT_CONTACT=<your contact into>`
- `BW2_DEFAULT_EXPIRY=<default expiry; recommended > 10y`
- `INSTALL_GO=true`
- `INSTALL_SPAWNPOINT_CLIENT=true`
- `INSTALL_PUNDAT_CLIENT=true`
- `CONFIGURE_NAMESPACE=false`
- `INSTALL_SPAWNPOINT_SERVER=true`
- `INSTALL_WATCHDOGS=true`

Then run the installation script in the same directory

```
curl -O https://raw.githubusercontent.com/SoftwareDefinedBuildings/XBOS/master/commissioning/install.sh
byobu new-session
./install.sh
```

### Installation Details


The blockchain takes up ~25GB of disk space. The installed BOSSWAVE agent will need to "catch up" on the blockchain by downloading the entire blockchain from peers and verifying its content. You can see the status of this process by running `bw2 status`:

```bash
$ bw2 status
 ╔╡172.17.0.1:28589 2.7.6 'Klystron'
 ╚╡peers=3 block=4171108 age=47s
BW2 Local Router status:
    Peer count: 3            <-- how many peers you are connected to
 Current block: 4171108      <-- how much you have downloaded
    Seen block: 4171108      <-- the amount you need to have downloaded
   Current age: 47s          <-- how old the "current block" is
    Difficulty: 24271799     <-- internal statistic
```

There are a few environment variables you will want installed on your system to make working with BOSSWAVE easier:
- `BW2_AGENT`: this is the local address of your BOSSWAVE agent.
	- example: `127.0.0.1:28589` (default)
- `BW2_DEFAULT_ENTITY`: the full path to the entity you want to use. This is typically an "administrative entity" with liberal permissions, which is used to grant more restrictive permissions to other entities
- `BW2_DEFAULT_BANKROLL`: the full path to the entity that has Ethereum cash attached to it. These funds are used to pay miners to insert records into the blockchain
- `BW2_DEFAULT_CONTACT`: the name/email address associated with this entity
	- example: `Gabe Fierro <email_address@berkeley.edu>`
- `BW2_DEFAULT_EXPIRY`: the default expiry time to use. By default this is 30 days (`30d`), so you will likely want to increase this:
	- example: `20y` (20 years)


### Common Problems

- If `Peer count` is 0, check your internet connection.
- If you are seeing errors like "Chain is too old", then you may not be caught up on the chain. Check the peer count and your internet connection
- If the agent process is constantly crashing, look at the logs (`sudo journalctl -f -u bw2` on Linux). You may need to delete the old blockchain (`rm -rf /var/lib/bw2`) and re-download.


## Entities

A BOSSWAVE entity is a public/private key pair and associated metadata:

- contact
- description
- creation time
- expiry time
- Ethereum cash balances

The public key is usually referred to as the **verifying key** or **VK**. We identify entities by VK. The private key is referred to as the **signing key** or **SK**. Permissions are granted from entities to entities. Each router, process, driver and individual in an XBOS deployment has an entity.

### Creating an Entity

To create an entity, we invoke the command line utility

```
NAME:
   bw2 mkentity - create a new entity

USAGE:
   bw2 mkentity [command options] [arguments...]

OPTIONS:
   --contact value, -c value	contact attribute e.g. 'Oski Bear <oski@berkeley.edu>' [$BW2_DEFAULT_CONTACT]
   --comment value, -m value	comment attribute e.g. 'Development Key'
   --revoker value, -r value	add a delegated revoker to this entity [$BW2_DEFAULT_REVOKER]
   --expiry value, -e value	set the expiry measured from now e.g. 10d5h10s (default: "30d") [$BW2_DEFAULT_EXPIRY]
   --outfile value, -o value	save the result to this file
   --nopublish, -n		do not publish to the registry
   --bankroll value, -b value	entity to pay for operation [$BW2_DEFAULT_BANKROLL]
```

Example:

```
bw2 mkentity -o myentity.ent -m "My administrative entity" -c "Gabe Fierro <gtfierro AT cs DOT berkeley DOT edu>"
```

Creating an entity involves publishing it to the blockchain so that other processes can use it. This requires funds provided by a bankroll entity, which can be specified explicitly using the `-b` flag or implicitly using the `$BW2_DEFAULT_BANKROLL` environment key.

### Getting Funds

To get Ethereum cash, you can always ask a current BOSSWAVE user to send you some.

You can also **mine** your own funds. Edit the BOSSWAVE agent configuration file (`/etc/bw2/bw2.ini` by default), and increase the `Threads` count (at the bottom) to be > 0. This is the number of CPUs your computer will use to mine. Be advised that mining typically uses the full CPU, so we don't recommend using more than half of your cores.

## Namespaces

All URIs in BOSSWAVE begin with a verifying key. The group of URIs that begin with the same verifying key all belong to the same **namespace**. The verifying key identifies the entity who has "root permissions" on the namespace. All valid Declarations of Trust (explained below) for URIs in a namespace must terminate at this root entity.

The **namespace entity** is usually created with a long expiry time and is stored offline.

### Aliases

To make verifying keys easier to work with, BOSSWAVE supports **aliases** which are immutable mappings of a verifying key to a human-readable string. These aliases can be used in place of the verifying key when interacting with URIs and performing other BOSSWAVE operations. For example, the verifying key `06DZ14k6dhRognGUoSHofD8oS8CUaWwq4tH-FPW13UU=` has the alias `xbos`, so the URI

```
06DZ14k6dhRognGUoSHofD8oS8CUaWwq4tH-FPW13UU=/thermostats/a/b/c
```
can also be written as
```
xbos/thermostats/a/b/c
```

To create an alias use the `bw2 mkalias` command:

```
bw2 mkalias --long "oski.demo" --b64 yDrnmqzJd6C7DF0c575upjQl3vOeCPSS9y4UVlKK8SY=
```

The `--b64` argument is the verifying key of the entity you want to create an alias for. `--long` is the alias itself.

### Designated Router

Recall that all URIs have a namespace, which is the verifying key that prefixes the URI. In order to *publish* and *subscribe* on URIs, the namespace needs to be *routable*, meaning it has a server that has agreed to carry the traffic on behalf of that namespace (i.e. be the *pub-sub broker* for the namespace). Usually, this server should be publicly addressable (with port 4514 open on the firewall), but some deployments may want to limit the accessibility.

Setting up a designated router for a namespace is a multi-step process. Both the entity of the router  and the namespace entity need to agree.

1. On the router, publish a `SRV` record to bind the IP and port of your server to the verifying key of the router. The `--dr` argument is the path to your router entity (`/etc/bw2/router.ent` by default):
	```
	sudo bw2 usrv --dr /etc/bw2/router.ent --srv 128.32.37.230:4514
	```
	You may need to refer directly to the `bw2` executable when using sudo:
	```
	sudo /usr/local/bin/bw2 usrv --dr /etc/bw2/router.ent --srv 128.32.37.230:4514
	```
2. On the router, make a *routing offer*. The `--ns` argument is the verifying key or alias of the namespace you want to route traffic for
	```
	sudo bw2 mkdroffer --dr /etc/bw2/router.ent --ns mynamespace
	```
3. Verify that this worked by querying for routing offers
	```
	$ bw2 listDRoffers --ns oski.demo
	No accepted offers found
	There are 1 open offers:
 		SNZv19fX34Zyj0tNu_EzLDmB7kDLOFrFcfnzSaWsHiA=
	```
4. On a machine that has access to the namespace key, accept the routing offer. The `--ns` argument is the path to the entity file for the namespace. We need to specify the entity file and not the verifying key because the entity file contains the private key, which is needed to sign this operation. The `--dr` argument is the verifying key of the router we want to carry traffic for our namespace. This can be found using the `listDRoffers` command above
	```
	bw2 acceptDRoffer --ns ns.ent --dr SNZv19fX34Zyj0tNu_EzLDmB7kDLOFrFcfnzSaWsHiA=
	```
5. Verify that this worked by re-checking the routing offers:
	```
	bw2 listDRoffers --ns oski.demo
 	Active affinity:
   		NS : yDrnmqzJd6C7DF0c575upjQl3vOeCPSS9y4UVlKK8SY=
   		DR : SNZv19fX34Zyj0tNu_EzLDmB7kDLOFrFcfnzSaWsHiA=
  		SRV : 128.32.37.230:4514
 	There are 1 open offers:
  		SNZv19fX34Zyj0tNu_EzLDmB7kDLOFrFcfnzSaWsHiA=
  	```

### Administration

Administration of a namespace is usually delegated to an **administrative entity** who has been given full permissions on the namespace. This administrative entity is usually owned by an individual (one or more) who performs most of the granting/revoking of permissions on that namespace. An entity can be an administrator for more than one namespace. Being the administrator for a namespace is only recommended a pattern for managing permissions  -- it is not enforced by BOSSWAVE.

## Permissions

For the sake of example, let us create a few entities that will represent colleagues. We defer the publish to the end to avoid multiple waits for confirmations

```
bw2 mke -o alice.ent --nopublish
bw2 mke -o bob.ent --nopublish
bw2 mke -o carol.ent --nopublish
bw2 i --publish *.ent
```

To keep things simple, we are going to use some dummy URIs. Later, we will see how URIs are structured and how to deploy BW services.

Let us say that Alice is the head of engineering. She ought to be able to do anything under the engineering section of the namespace. We can codify that as:

```
bw2 mkdot --from ns.ent --to alice.ent --uri "oski.demo/engineering/*" --ttl 5 --permissions "PC*"
```

This says that `alice.ent` is allowed to publish (P) and subscribe (C) including wildcards (`*`) on any URI beginning with oski.demo/engineering. The TTL parameter specifies over how many hops this this trust can be *re-delegated*. By default it is zero which says that we trust alice (one hop), but do not trust the people that she trusts (more than one hop). Note that although we are using alice.ent (the private key file) as a target for convenience, we could also use the full VK or an alias as the 'to' parameter. The 'from' parameter must be a private keyfile.

Let us say that Bob is in charge of making reports, so Alice wants him to be able to read all the resources from the 'epic' project:

```
bw2 mkdot --from alice.ent --to bob.ent --uri "oski.demo/engineering/projects/epic/*" --permissions "C*"
```

Now let us see how this chain of trust is working. Let's ask bw2 to try find a chain of trust that allows bob to subscribe to some sensor data. As a small note, if you are following along extremely fast, the client BCIP of 2 confirmations is less strict than the code that validates permissions, which requires 5 confirmations, so you may need to wait 3 blocks (a minute or two) after executing the previous mkdot command and the following builchain command.

```
bw2 buildchain -t bob.ent --uri "oski.demo/engineering/projects/epic/sensorobj/interface" -x "C"
```

You should see something similar to:

```
┣┳ DChain hash= bBrkiAnbIYafEMjYk0jwDVybgcOXUhSSZFztTh0uwEQ=
┃┣ Registry: UNKNOWN
┃┣ Elaborated: True
┃┣ Grants: C*
┃┣ On: yDrnmqzJd6C7DF0c575upjQl3vOeCPSS9y4UVlKK8SY=/engineering/projects/epic/*
┃┣ End TTL: 0
```

> Outline:
> - granting permissions
> 	+ bw2 guide from readme
> 	+ URIs patterns in XBOS
> 	+ grant/check tools for XBOS services
> 	+ checking for permissions
> 	+ patterns
