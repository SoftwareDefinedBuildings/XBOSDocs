
## XBOS Demand Response

**Interface**: i.xbos.demand_response

**Description**: Standard XBOS demand response event interface

**PONUM**: 2.1.1.9

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| dr_status | integer | The local site's status regarding the DR event | dr_status | true |
| event_end | integer | DR event end time, expressed as nanoseconds since the Unix epoch | ns | true |
| event_start | integer | DR event start time, expressed as nanoseconds since the Unix epoch | ns | true |
| event_type | integer | The type (severity) of the DR event | event_type | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `event_start`
    - `event_end`
    - `event_type`
    - `dr_status`
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

	base_uri := "Demand Response uri goes here ending in i.xbos.demand_response"

	// subscribe
	type signal struct {
		Event_start int64 `msgpack:"event_start"`
		Event_end   int64 `msgpack:"event_end"`
		Event_type  int64 `msgpack:"event_type"`
		Dr_status   int64 `msgpack:"dr_status"`
		Time        int64 `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.9/32")
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
    if po.type_dotted == (2,1,1,9):
      print msgpack.unpackb(po.content)

bw_client.subscribe("Demand Response uri ending in i.xbos.demand_response/signal/info", onMessage)

print "Subscribing. Ctrl-C to quit."
while True:
  time.sleep(10000)
```
