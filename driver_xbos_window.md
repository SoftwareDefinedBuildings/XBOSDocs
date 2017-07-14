
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

	base_uri := "Window uri goes here ending in i.xbos.window"

	// subscribe
	type signal struct {
		State bool  `msgpack:"state"`
		Time  int64 `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.5/32")
		err := po.(bw2.MsgPackPayloadObject).ValueInto(&current_state)
		if err != nil {
			fmt.Println(err)
		} else {
			fmt.Println(current_state)
		}
	}
}
```
