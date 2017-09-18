
## XBOS Weather Station

**Interface**: i.xbos.weather_station

**Description**: XBOS weather station

**PONUM**: 2.1.1.8

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| relative_humidity | double | Current relative humidity | percent | false |
| temperature | double | Current temperature reading | Fahrenheit | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |
| wind_speed | double | Current wind speed in miles per hour | mph | false |


### Signals
- `info`:
    - `temperature`
    - `relative_humidity`
    - `wind_speed`
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

	base_uri := "Weather Station uri goes here ending in i.xbos.weather_station"

	// subscribe
	type signal struct {
		Temperature       float64 `msgpack:"temperature"`
		Relative_humidity float64 `msgpack:"relative_humidity"`
		Wind_speed        float64 `msgpack:"wind_speed"`
		Time              int64   `msgpack:"time"`
	}
	c, err := client.Subscribe(&bw2.SubscribeParams{
		URI: base_uri + "/signal/info",
	})
	if err != nil {
		panic(err)
	}

	for msg := range c {
		var current_state signal
		po := msg.GetOnePODF("2.1.1.8/32")
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
    if po.type_dotted == (2,1,1,8):
      print msgpack.unpackb(po.content)

bw_client.subscribe("Weather Station uri ending in i.xbos.weather_station/signal/info", onMessage)

print "Subscribing. Ctrl-C to quit."
while True:
  time.sleep(10000)
```
