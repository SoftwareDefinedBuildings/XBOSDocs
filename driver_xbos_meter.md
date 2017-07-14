
## XBOS Meter

**Interface**: i.xbos.meter

**Description**: Standard XBOS electric meter interface

**PONUM**: 2.1.1.4

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| current_demand | double | Current measured demand | KW | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `current_demand`
    - `time`
    


### Slots

