
## XBOS Window

**Interface**: i.xbos.window

**Description**: Standard XBOS operable window interface

**PONUM**: 2.1.1.5

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| state | boolean | Whether or not the window is open | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `state`
    - `time`
    


### Slots

