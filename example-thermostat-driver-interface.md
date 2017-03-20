# Example: XBOS Thermostat Interface

Here we expand the [XBOS thermostat interface](https://github.com/SoftwareDefinedBuildings/XBOS/blob/master/interfaces/xbos_thermostat.yaml) into a tabular form, and explore the URIs and messages and PO nums and permissions involved.

For this example, we will assume the following:

* we are using a Venstar thermostat \(with its [corresponding driver](https://github.com/SoftwareDefinedBuildings/bw2-contrib/tree/master/driver/venstar\)\), so we will see its service name, `s.venstar`
* the base URI of the driver is `myhome/devices`
* the Venstar driver exposes a single instance of a thermostat that we call "Kitchen"
* this instance exposes the standard XBOS thermostat interface \(`i.xbos.thermostat`\)

#### Properties

Properties are the names to be used in the messages published and consumed on the URIs of this driver. These properties will be referenced in the Messages section below

| **Name** | **Type** | **Description** | **Units** | Required |
| :--- | :--- | :--- | :--- | :--- |
| temperature | double | Current temperature reading at the thermostat | Fahrenheit | true |
| relative\_humidity | double | Current relative humidity reading at the thermostat | Percent | false |
| heating\_setpoint | double | Current heating setpoint | Fahrenheit | true |
| cooling\_setpoint | double | Current cooling setpoint | Fahrenheit | true |
| override | boolean | Override state of the thermostat. If the thermostat is in override mode, it will not follow its programmed schedule. |  | true |
| fan | boolean | Fan state of the thermostat |  | false |
| mode | integer | The current operating policy of the thermostat |  | true |
| state | integer | The current state of the thermostat |  | true |

#### URIs

Put a table of signal/slot URIs here and what's on those

The signals and slots \(and associated properties\) for our deployed thermostat are:

* `myhome/devices/s.venstar/Kitchen/i.xbos.thermostat/signal/info`
  * temperature
  * relative\_humidity
  * heating\_setpoint
  * cooling\_setpoint
  * override
  * fan
  * mode
  * state
* `myhome/devices/s.venstar/Kitchen/i.xbos.thermostat/slot/setpoints`
  * heating\_setpoint
  * cooling\_setpoint
* `myhome/devices/s.venstar/Kitchen/i.xbos.thermostat/slot/state`
  * heating\_setpoint
  * cooling\_setpoint
  * override
  * mode
  * fan

#### Messages

The contents of the messages published on the above URIs are determined by the properties we want to include in those interfaces.

All of these payload objects use the PO num `2.1.1.0`, as specified in the XBOS thermostat interface file.

A sample message published on the `info` signal would be the msgpack-serialized form of

```json
{
    "temperature": 71.1,
    "relative_humidity": 48.9,
    "heating_setpoint": 70,
    "cooling_setpoint": 82,
    "override": 0,
    "fan": 0,
    "mode": 3,
    "state": 0
}
```



To actuate the heating setpoint, we would send the following message \(serialized as msgpack\) to either the `setpoints` or `state` signal \(depending on what we have permission to do\)

```json
{
    "heating_setpoint": 80
}
```



