
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
		Current_demand float64 `msgpack:"current_demand"`
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
