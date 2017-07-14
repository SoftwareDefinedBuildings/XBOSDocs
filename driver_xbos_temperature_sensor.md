
## XBOS Temperature Sensor

**Interface**: i.xbos.temperature_sensor

**Description**: XBOS temperature sensor

**PONUM**: 2.1.2.0

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| temperature | double | Current temperature reading | Fahrenheit | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `temperature`
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

	base_uri := "Temperature Sensor uri goes here ending in i.xbos.temperature_sensor"

	// subscribe
	type signal struct {
		temperature float64
		time        int64
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.2.0/32")
		po.(bw2.MsgPackPayloadObject).ValueInto(&current_state)
		fmt.Println(current_state)
	}
}
```
