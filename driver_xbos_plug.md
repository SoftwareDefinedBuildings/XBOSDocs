
## XBOS Plug

**Interface**: i.xbos.plug

**Description**: Standard XBOS plug interface

**PONUM**: 2.1.1.2

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| cumulative | float | an aggregation from some epoch of true power (Kilo Watt Hours) | kWh | false |
| current | float | current through the plug (Amperes) | A | false |
| power | float | true power through the plug (Kilo Watts) | W | false |
| state | boolean | Whether or not the plug is enabled | on/off | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |
| voltage | float | voltage at the plug (Volts) | V | false |


### Signals
- `info`:
    - `state`
    - `time`
    - `voltage`
    - `current`
    - `power`
    - `cumulative`
    


### Slots
- `state`:
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

	base_uri := "Plug uri goes here ending in i.xbos.plug"

	// subscribe
	type signal struct {
		State      bool  `msgpack:"state"`
		Time       int64 `msgpack:"time"`
		Voltage    float `msgpack:"voltage"`
		Current    float `msgpack:"current"`
		Power      float `msgpack:"power"`
		Cumulative float `msgpack:"cumulative"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.2/32")
		err := po.(bw2.MsgPackPayloadObject).ValueInto(&current_state)
		if err != nil {
			fmt.Println(err)
		} else {
			fmt.Println(current_state)
		}
	}
}
```
