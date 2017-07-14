
## XBOS Temperature Sensor

**Interface**: i.xbos.temperature_sensor

**Description**: XBOS temperature sensor

**PONUM**: 2.1.2.0

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| temperature | double | Current temperature reading | Fahrenheit | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `temperature`
    - `time`
    


### Slots

