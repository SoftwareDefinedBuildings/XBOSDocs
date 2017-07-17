
## XBOS Meter

**Interface**: i.xbos.meter

**Description**: Standard XBOS electric meter interface

**PONUM**: 2.1.1.4

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| apparent_power | double | Current apparent power reading | kVA | false |
| power | double | Current measured power | kW | true |
| time | integer | nanoseconds since the Unix epoch | ns | true |
| voltage | double | Current voltage reading | V | false |


### Signals
- `info`:
    - `power`
    - `voltage`
    - `apparent_power`
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

	base_uri := "Meter uri goes here ending in i.xbos.meter"

	// subscribe
	type signal struct {
		Power          float64 `msgpack:"power"`
		Voltage        float64 `msgpack:"voltage"`
		Apparent_power float64 `msgpack:"apparent_power"`
		Time           int64   `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.4/32")
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
    if po.type_dotted == (2,1,1,4):
      print msgpack.unpackb(po.content)

bw_client.subscribe("Meter uri ending in i.xbos.meter/signal/info", onMessage)

print "Subscribing. Ctrl-C to quit."
while True:
  time.sleep(10000)
```
