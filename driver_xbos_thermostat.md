
## XBOS Thermostat

**Interface**: i.xbos.thermostat

**Description**: Standard XBOS thermostat interface

**PONUM**: 2.1.1.0

### Properties

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
    

