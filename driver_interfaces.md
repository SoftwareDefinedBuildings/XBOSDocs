# Driver Interfaces

{% method -%}
## Signals and Slots {#signalsandslots}

**Signals** are URIs on which a driver publishes data and state

**Slots** are URIs on which a driver receives input, e.g. actuation commands

{% sample -%}
```bash
mydeployment/devices/s.thermostat/bedroom/i.thermostat/signal/temperature
```

{% endmethod %}

### Thermostat

#### Signals

| Signal Name | Valid Values |
| ----------- | ------------ |
| `temperature`       | `float` values |
| `relative_humidity` | `float` values |
| `heating_setpoint`  | `float` values |
| `cooling_setpoint`  | `float` values |
| `override`          | `1` if the thermostat is in override mode, else `0` |
| `mode`              | <ul><li>`0`: Off</li> <li>`1`: Heating</li> <li>`2`: Cooling</li> <li>`3`: Auto</li> |
| `state`             | <ul><li>`0`: Off</li> <li>`1`: Heating</li> <li>`2`: Cooling</li> <li>`3`: Auto</li> |
| `fan`               | `1` if the fan is enabled, else `0` |

#### Slots

### Lighting

### Plug

### Meter

### Sensor
