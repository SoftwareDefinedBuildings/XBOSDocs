
## XBOS Demand Response Forecast

**Interface**: i.xbos.demand_response_confirmed

**Description**: Standard XBOS confirmed demand response events interface

**PONUM**: 2.1.1.10

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| date | integer | nanoseconds since the Unix epoch for a given day (at midnight local time) | ns | true |
| event_status | integer | The status of a DR event for a given day | event_status | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `event_status`
    - `date`
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

	base_uri := "Demand Response Forecast uri goes here ending in i.xbos.demand_response_confirmed"

	// subscribe
	type signal struct {
		Event_status int64 `msgpack:"event_status"`
		Date         int64 `msgpack:"date"`
		Time         int64 `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.10/32")
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
    if po.type_dotted == (2,1,1,10):
      print msgpack.unpackb(po.content)

bw_client.subscribe("Demand Response Forecast uri ending in i.xbos.demand_response_confirmed/signal/info", onMessage)

print "Subscribing. Ctrl-C to quit."
while True:
  time.sleep(10000)
```
