
## XBOS Plug

**Interface**: i.xbos.plug

**Description**: Standard XBOS plug interface

**PONUM**: 2.1.1.2

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| cumulative | float | an aggregation from some epoch of true power (Kilo Watt Hours) | kWh | false |
| current | float | current through the plug (Amperes) | A | false |
| power | float | true power through the plug (Kilo Watts) | W | false |
| state | boolean | Whether or not the plug is enabled | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |
| voltage | float | voltage at the plug (Volts) | V | false |


### Signals
- `info`:
    - `state`
    - `time`
    - `voltage`
    - `current`
    - `power`
    - `cumulative`
    


### Slots
- `state`:
    - `state`
    

