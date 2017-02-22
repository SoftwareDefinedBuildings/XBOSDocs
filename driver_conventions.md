# Driver Conventions

## Driver URIs

When writing a driver, thought must be given as to how to decompose a driver's functionality. There are several levels of decomposition in a driver, which are best explored with the context of an example URI:

```
<namespace>/base/uri/<service name>/<instance>/<interface name>/{signal,slot}/<name>
```

BOSSWAVE processes will publish and subscribe on URIs that match this template. `base/uri` represents any intermediate path between `<namespace>` and `<service name>`

* **Namespace**: the public key of the namespace. To participate on any URI starting with the namespace, a declaration of trust (DOT) must exist from the namespace key to the participating key
* **Service Name**: typically vendor or device specific, e.g. "s.lifx", "s.venstar". The base/root URI of a service represents the instantiation of that service
* **Interface Name**: a standard XBOS interface name, describing a generic function of the device, e.g. "i.xbos.light", "i.xbos.thermostat". Interfaces are well-defined; a standard set of XBOS interfaces exists [here](https://docs.xbos.io/driver_interfaces.html)
* **Instance**: A particular instance of a service may expose several instances of an interface. In the case where there is only one instance of an interface for a service, the instance is conventionally denoted as the underscore character (`_`). Interfaces define the particular signals, slots and messages published
* **Signals, Slots**: signals are outputs of the driver. Slots are input
* **Name**: The name of the particular signal or slot

## Message Types

For now, XBOS messages published on BOSSWAVE are serialized using [msgpack](http://msgpack.org/index.html), an efficient binary format similar to a typed-JSON.
