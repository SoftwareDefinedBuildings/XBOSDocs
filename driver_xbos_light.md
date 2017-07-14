
## XBOS Light

**Interface**: i.xbos.light

**Description**: Standard XBOS lighting interface

**PONUM**: 2.1.1.1

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| brightness | integer | Current brightness of the light; 100 is maximum brightness | percentage | false |
| state | boolean | Whether or not the light is on | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `state`
    - `brightness`
    - `time`
    


### Slots
- `state`:
    - `state`
    - `brightness`
    

