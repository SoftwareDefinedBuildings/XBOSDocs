# Example: XBOS Thermostat Interface

Here we expand the [XBOS thermostat interface](https://github.com/SoftwareDefinedBuildings/XBOS/blob/master/interfaces/xbos_thermostat.yaml) into a tabular form, and explore the URIs and messages and PO nums and permissions involved.

For this example, we will assume the following:

* we are using a Venstar thermostat \(with its [corresponding driver](https://github.com/SoftwareDefinedBuildings/bw2-contrib/tree/master/driver/venstar)\), so we will see its service name, `s.venstar`
* the base URI of the driver is `myhome/devices`

#### Properties

Reproduce the list of properties for the tstat interface

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

#### Messages

Go over what would be sent on the URIs

