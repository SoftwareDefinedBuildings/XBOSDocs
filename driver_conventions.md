# Driver Conventions

## Driver URIs

In a BOSSWAVE URI, we use the following standard structure:![](/assets/BOSSWAVE URI Decomp.png)

`<namespace>/...`:  This is usually referred to as the **prefix** or the **base URI**. Drivers will be written to publish/consume data on URIs that are relative to the prefix, which simplifies deployment.

`<service name>`: By convention, these start with `s.` \(e.g. `s.venstar` for the Venstar-brand thermostat\). A service is a name for a particular grouping of interfaces \(see below\), and typically represents an _instance_ of a driver. A driver may expose more than one service, and a service may be composed of multiple drivers \(rare\).

`<instance name>`: A driver or service may expose several _instances_ of an interface. In the case where there is only one instance of an interface for a service, the instance is conventionally denoted as the underscore character \(`_`\). Otherwise, the instances are conventionally given some human-readable name that helps differentiate them. For example, a thermostat service that exposes multiple thermostats might name instances by which room the thermostats are in \(**note:** this kind of naming should _not_ be considered in place of proper metadata\)

`<interface name>`: By convention, these start with `i.` \(e.g. `i.xbos.thermostat` for the standard XBOS thermostat interface\). Interfaces encapsulate a set of signals and slots \(see below\). Interfaces are well-defined, and a standard set of XBOS interfaces exist [here](https://docs.xbos.io/driver_interfaces.html).

`signal`: is a keyword in the URI that indicates that the name specified afterwards is an _output_ of the driver

`slot`: is a keyword in the URI that indicates that the name specified afterwards is an _input_ to the driver

`<signal, slot name>`: this is the name of the signal or slot. These are defined by the corresponding interface.

## Message Types and Payload Objects

All messages exchanged on BOSSWAVE contain 0 or more **payload objects**. A payload object is a combination of a serialized binary data blob and a **payload object ID number** \(or **PO num**\). A **PO num** is a 32-bit number \(typically written in dot-decimal form\) that represents a combination of the _serialization \_and \_contents_ of the corresponding binary data blob.

The [bw2\_pid](https://github.com/immesys/bw2_pid) repository contains the current allocations of PO nums and what they mean. Each XBOS interface defines a set of PO nums for the messages it publishes. By keeping PO nums consistent, consumers of data can easily find the relevant pieces of data in published data.

As of this date, XBOS messages mostly use the [msgpack](http://msgpack.org/index.html\) serialization format \(PO num `2.0.0.0/24` \) serialization format \(PO num `2.0.0.0/24`\).

## Permissions

The BOSSWAVE URI structure allows us different permission granularities, based on what URI pattern we grant to. There are 2 main flavors of BOSSWAVE permissions: _publish_ and _consume. \_In BOSSWAVE, an entity can be granted permission to \_publish_ or _consume_ on a URI pattern; for a given URI, the entity is allowed to perform a requested action only if it has been granted that permission on a matching URI pattern.

**Note**: right now we assume an understanding of `*`, `+`, `P`, `C`, `C+` and `C*` in the context of BOSSWAVE permissions.

Here are some common permission patterns in XBOS:

* `<namespace>/.../<service name>/*`:

  * access to a particular service

* `<namespace>/.../<service name>/<instance name>/*`:

  * access to all interfaces for particular instance within a service

* `<namespace>/.../<service name>/<instance name>/<interface name>/*`:

  * access to a particular interface of a given instance

* `<namespace>/.../<service name>/<instance name>/<interface name>/signal/<signal name>`:

  * access to a particular signal for a particular interface for a given instance
  * Typically only read-permissions are given here \(`C`/consume permissions\)

* `<namespace>/.../<service name>/<instance name>/<interface name>/slot/<slot name>`:
  * access to a particular slot for a particular interface for a given instance

Using BOSSWAVE's URI patterns, we can grant more general permissions as well; for example

* `<namespace>/.../<service name>/+/<interface name>/signal/+`:
  * access to all signals for all instances that expose a given interface



## Designing Signals and Slots





