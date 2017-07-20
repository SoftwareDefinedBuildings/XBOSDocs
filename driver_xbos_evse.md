
## XBOS EVSE

**Interface**: i.xbos.evse

**Description**: Standard XBOS electric vehicle supply equipment (charging station)

**PONUM**: 2.1.1.7

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| charging_time_left | integer | Seconds left until car is fully charged | s | false |
| current | double | Active charge current | A | true |
| current_limit | double | Maximum allowed current for charging | A | true |
| state | boolean | Charge state of the EVSE | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | true |
| voltage | double | Active charge voltage | V | true |


### Signals
- `info`:
    - `current_limit`
    - `current`
    - `state`
    - `voltage`
    - `charging_time_left`
    - `time`
    


### Slots
- `state`:
    - `current_limit`
    - `state`
    


### Interfacing in Go

```go
package main

import (
	"fmt"
	bw2 "gopkg.in/immesys/bw2bind.v5"
)

func main() {
	client := bw2.ConnectOrExit("")
	client.OverrideAutoChainTo(true)
	client.SetEntityFromEnvironOrExit()

	base_uri := "EVSE uri goes here ending in i.xbos.evse"

	// subscribe
	type signal struct {
		Current_limit      float64 `msgpack:"current_limit"`
		Current            float64 `msgpack:"current"`
		State              bool    `msgpack:"state"`
		Voltage            float64 `msgpack:"voltage"`
		Charging_time_left int64   `msgpack:"charging_time_left"`
		Time               int64   `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.7/32")
		err := po.(bw2.MsgPackPayloadObject).ValueInto(&current_state)
		if err != nil {
			fmt.Println(err)
		} else {
			fmt.Println(current_state)
		}
	}
}
```
### Interfacing in Python

```python

import time
import msgpack

from bw2python.bwtypes import PayloadObject
from bw2python.client import Client

bw_client = Client()
bw_client.setEntityFromEnviron()
bw_client.overrideAutoChainTo(True)

def onMessage(bw_message):
  for po in bw_message.payload_objects:
    if po.type_dotted == (2,1,1,7):
      print msgpack.unpackb(po.content)

bw_client.subscribe("EVSE uri ending in i.xbos.evse/signal/info", onMessage)

print "Subscribing. Ctrl-C to quit."
while True:
  time.sleep(10000)
```
