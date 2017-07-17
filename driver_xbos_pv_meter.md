
## XBOS PV Meter

**Interface**: i.xbos.pv_meter

**Description**: Standard XBOS photovoltaic interface

**PONUM**: 2.1.1.6

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| current_power | double | Current power generated | W | true |
| time | integer | nanoseconds since the Unix epoch | ns | true |
| total_energy_lifetime | double | Energy produced over Enphase lifetime | Wh | false |
| total_energy_today | double | Energy produced today | Wh | false |


### Signals
- `info`:
    - `current_power`
    - `total_energy_lifetime`
    - `total_energy_today`
    - `time`
    


### Slots


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

	base_uri := "PV Meter uri goes here ending in i.xbos.pv_meter"

	// subscribe
	type signal struct {
		Current_power         float64 `msgpack:"current_power"`
		Total_energy_lifetime float64 `msgpack:"total_energy_lifetime"`
		Total_energy_today    float64 `msgpack:"total_energy_today"`
		Time                  int64   `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.6/32")
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
    if po.type_dotted == (2,1,1,6):
      print msgpack.unpackb(po.content)

bw_client.subscribe("PV Meter uri ending in i.xbos.pv_meter/signal/info", onMessage)

print "Subscribing. Ctrl-C to quit."
while True:
  time.sleep(10000)
```
