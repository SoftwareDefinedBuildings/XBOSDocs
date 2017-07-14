# Driver Interfaces

> These are currently [under development](https://github.com/SoftwareDefinedBuildings/XBOS/tree/master/interfaces)
>
> Discussion of these interfaces is taking place on the [XBOS issue tracker](https://github.com/SoftwareDefinedBuildings/XBOS/issues/1)

<a name="Light"></a>
## XBOS Light

**Interface**: i.xbos.light

**Description**: Standard XBOS lighting interface

**PONUM**: 2.1.1.1

### <a name="LightProperties"></a>Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| brightness | integer | Current brightness of the light; 100 is maximum brightness | percentage | false |
| state | boolean | Whether or not the light is on | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


<a name="LightSignals"></a>
### Signals
- `info`:
    - `state`
    - `brightness`
    - `time`
    


<a name="LightSlots"></a>
### Slots
- `state`:
    - `state`
    - `brightness`
    


<a name="Meter"></a>
## XBOS Meter

**Interface**: i.xbos.meter

**Description**: Standard XBOS electric meter interface

**PONUM**: 2.1.1.4

### <a name="MeterProperties"></a>Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| current_demand | double | Current measured demand | KW | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


<a name="MeterSignals"></a>
### Signals
- `info`:
    - `current_demand`
    - `time`
    


<a name="MeterSlots"></a>
### Slots


<a name="Plug"></a>
## XBOS Plug

**Interface**: i.xbos.plug

**Description**: Standard XBOS plug interface

**PONUM**: 2.1.1.2

### <a name="PlugProperties"></a>Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| cumulative | float | an aggregation from some epoch of true power (Kilo Watt Hours) | kWh | false |
| current | float | current through the plug (Amperes) | A | false |
| power | float | true power through the plug (Kilo Watts) | W | false |
| state | boolean | Whether or not the plug is enabled | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |
| voltage | float | voltage at the plug (Volts) | V | false |


<a name="PlugSignals"></a>
### Signals
- `info`:
    - `state`
    - `time`
    - `voltage`
    - `current`
    - `power`
    - `cumulative`
    


<a name="PlugSlots"></a>
### Slots
- `state`:
    - `state`
    


<a name="Temperature Sensor"></a>
## XBOS Temperature Sensor

**Interface**: i.xbos.temperature_sensor

**Description**: XBOS temperature sensor

**PONUM**: 2.1.2.0

### <a name="Temperature SensorProperties"></a>Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| temperature | double | Current temperature reading | Fahrenheit | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


<a name="Temperature SensorSignals"></a>
### Signals
- `info`:
    - `temperature`
    - `time`
    


<a name="Temperature SensorSlots"></a>
### Slots


<a name="Thermostat"></a>
## XBOS Thermostat

**Interface**: i.xbos.thermostat

**Description**: Standard XBOS thermostat interface

**PONUM**: 2.1.1.0

### <a name="ThermostatProperties"></a>Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| cooling_setpoint | double | Current cooling setpoint | Fahrenheit | true |
| fan | boolean | Fan state of the thermostat | on/off | false |
| heating_setpoint | double | Current heating setpoint | Fahrenheit | true |
| mode | integer | The current operating policy of the thermostat | mode | true |
| override | boolean | Override state of the thermostat. If the thermostat is in override mode, it will not follow its programmed schedule. | on/off | true |
| relative_humidity | double | Current relative humidity reading at the thermostat | Percent | false |
| state | integer | The current state of the thermostat | state | true |
| temperature | double | Current temperature reading at the thermostat | Fahrenheit | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


<a name="ThermostatSignals"></a>
### Signals
- `info`:
    - `temperature`
    - `relative_humidity`
    - `heating_setpoint`
    - `cooling_setpoint`
    - `override`
    - `fan`
    - `mode`
    - `state`
    - `time`
    


<a name="ThermostatSlots"></a>
### Slots
- `setpoints`:
    - `heating_setpoint`
    - `cooling_setpoint`
    
- `state`:
    - `heating_setpoint`
    - `cooling_setpoint`
    - `override`
    - `mode`
    - `fan`
    


<a name="Window"></a>
## XBOS Window

**Interface**: i.xbos.window

**Description**: Standard XBOS operable window interface

**PONUM**: 2.1.1.5

### <a name="WindowProperties"></a>Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| state | boolean | Whether or not the window is open | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


<a name="WindowSignals"></a>
### Signals
- `info`:
    - `state`
    - `time`
    


<a name="WindowSlots"></a>
### Slots

