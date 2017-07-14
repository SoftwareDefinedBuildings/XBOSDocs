
## XBOS Light

**Interface**: i.xbos.light

**Description**: Standard XBOS lighting interface

**PONUM**: 2.1.1.1

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| brightness | integer | Current brightness of the light; 100 is maximum brightness | percentage | false |
| state | boolean | Whether or not the light is on | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `state`
    - `brightness`
    - `time`
    


### Slots
- `state`:
    - `state`
    - `brightness`
    


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

	base_uri := "Light uri goes here ending in i.xbos.light"

	// subscribe
	type signal struct {
		State      bool  `msgpack:"state"`
		Brightness int64 `msgpack:"brightness"`
		Time       int64 `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.1/32")
		err := po.(bw2.MsgPackPayloadObject).ValueInto(&current_state)
		if err != nil {
			fmt.Println(err)
		} else {
			fmt.Println(current_state)
		}
	}
}
```
