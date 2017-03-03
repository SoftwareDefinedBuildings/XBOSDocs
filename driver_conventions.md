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

All messages exchanged on BOSSWAVE contain 0 or more **payload objects**. A payload object is a combination of a serialized binary data blob and a **payload object ID number** \(or **PO num**\). A **PO num** is a 32-bit number \(typically written in dot-decimal form\) that represents a combination of the _serialization _and _contents_ of the corresponding binary data blob.

The [bw2\_pid](https://github.com/immesys/bw2_pid) repository contains the current allocations of PO nums and what they mean. Each XBOS interface defines a set of PO nums for the messages it publishes. By keeping PO nums consistent, consumers of data can easily find the relevant pieces of data in published data.

As of this date, XBOS messages mostly use the [msgpack](http://msgpack.org/index.html) serialization format \(PO num `2.0.0.0/24` \).



