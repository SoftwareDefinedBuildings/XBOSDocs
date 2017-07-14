
## XBOS Thermostat

**Interface**: i.xbos.thermostat

**Description**: Standard XBOS thermostat interface

**PONUM**: 2.1.1.0

### Properties

| **Name** | **Type** | **Description** | **Units** | **Required** |
| :------- | :------- | :-------------- | :-------- | :----------- |
| cooling_setpoint | double | Current cooling setpoint | Fahrenheit | true |
| fan | boolean | Fan state of the thermostat | on/off | false |
| heating_setpoint | double | Current heating setpoint | Fahrenheit | true |
| mode | integer | The current operating policy of the thermostat | mode | true |
| override | boolean | Override state of the thermostat. If the thermostat is in override mode, it will not follow its programmed schedule. | on/off | true |
| relative_humidity | double | Current relative humidity reading at the thermostat | Percent | false |
| state | integer | The current state of the thermostat | state | true |
| temperature | double | Current temperature reading at the thermostat | Fahrenheit | true |
| time | integer | nanoseconds since the Unix epoch | ns | false |


### Signals
- `info`:
    - `temperature`
    - `relative_humidity`
    - `heating_setpoint`
    - `cooling_setpoint`
    - `override`
    - `fan`
    - `mode`
    - `state`
    - `time`
    


### Slots
- `setpoints`:
    - `heating_setpoint`
    - `cooling_setpoint`
    
- `state`:
    - `heating_setpoint`
    - `cooling_setpoint`
    - `override`
    - `mode`
    - `fan`
    


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

	base_uri := "Thermostat uri goes here ending in i.xbos.thermostat"

	// subscribe
	type signal struct {
		Temperature       float64 `msgpack:"temperature"`
		Relative_humidity float64 `msgpack:"relative_humidity"`
		Heating_setpoint  float64 `msgpack:"heating_setpoint"`
		Cooling_setpoint  float64 `msgpack:"cooling_setpoint"`
		Override          bool    `msgpack:"override"`
		Fan               bool    `msgpack:"fan"`
		Mode              int64   `msgpack:"mode"`
		State             int64   `msgpack:"state"`
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
		po := msg.GetOnePODF("2.1.1.0/32")
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
    if po.type_dotted == (2,1,1,0):
      print msgpack.unpackb(po.content)

bw_client.subscribe("Thermostat uri ending in i.xbos.thermostat/signal/info", onMessage)

print "Subscribing. Ctrl-C to quit."
while True:
  time.sleep(10000)
```
