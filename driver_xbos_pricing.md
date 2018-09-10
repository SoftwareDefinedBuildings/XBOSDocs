
## XBOS Utility Pricing

**Interface**: i.xbos.pricing

**Description**: Standard XBOS utility pricing interface - this is an array of the following inputs for a given interval (e.g., 24 hours)

**PONUM**: 2.1.1.3

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| duration | integer | The duration of the given price in seconds | s | true |
| price | double | The base price of energy per kWh or kW | currency | true |
| price_unit | integer | The currency of the given price | price_unit | true |
| start_time | integer | start time for the given price in nanoseconds since the Unix epoch | ns | true |
| time | integer | time in nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `start_time`
    - `duration`
    - `price`
    - `price_unit`
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

	base_uri := "Utility Pricing uri goes here ending in i.xbos.pricing"

	// subscribe
	type signal struct {
		Start_time int64   `msgpack:"start_time"`
		Duration   int64   `msgpack:"duration"`
		Price      float64 `msgpack:"price"`
		Price_unit int64   `msgpack:"price_unit"`
		Time       int64   `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.3/32")
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
    if po.type_dotted == (2,1,1,3):
      print msgpack.unpackb(po.content)

bw_client.subscribe("Utility Pricing uri ending in i.xbos.pricing/signal/info", onMessage)

print "Subscribing. Ctrl-C to quit."
while True:
  time.sleep(10000)
```
