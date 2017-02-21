# Driver Interfaces

## Signals and Slots {#signalsandslots}

**Signals** are URIs on which a driver publishes data and state

**Slots** are URIs on which a driver receives input, e.g. actuation commands

**TODO:** decide on and document standard PO types for signals and slots

### Thermostat: [`i.thermostat`](#i.thermostat)

#### Signals

| Signal Name | Valid Values | PO num |
| ----------- | ------------ | ----- |
| `temperature`       | `float` values | |
| `relative_humidity` | `float` values | |
| `heating_setpoint`  | `float` values | |
| `cooling_setpoint`  | `float` values | |
| `override`          | `1` if the thermostat is in override mode, else `0` | |
| `mode`              | <ul><li>0: Off</li> <li>1: Heating</li> <li>2: Cooling</li> <li>3: Auto</li> | |
| `state`             | <ul><li>0: Off</li> <li>1: Heating</li> <li>2: Cooling</li> <li>3: Auto</li> | |
| `fan`               | `1` if the fan is enabled, else `0` | |

#### Slots

| Slot Name | Valid Values | PO num |
| ----------- | ------------ | ----- |
| `heating_setpoint`  | `float` values | |
| `cooling_setpoint`  | `float` values | |
| `override`          | `1` to place the thermostat in override mode. `0` to disable override mode | |
| `mode`              | <ul><li>0: Off</li> <li>1: Heating</li> <li>2: Cooling</li> <li>3: Auto</li> | |
| `fan`               | `1` to enable the fan. `0` to disable the fan | |

---

### Lighting: [`i.light`](#i.light)

#### Signals

| Signal Name | Valid Values | PO num |
| ----------- | ------------ | ------ |
| `state`     | `1` if light is on, else `0` | |
| `brightness`| Integer scale from `0-100`, where `100` is full brightness | |
| `color`| TBD | |

#### Slots

| Slot Name | Valid Values | PO num |
| ----------- | ------------ | ----- |
| `state`     | `1` to turn the light on. `0` to turn it off | |
| `brightness`| Integer scale from `0-100`, where `100` is full brightness | |
| `color`| TBD | |

---

### Plug [`i.plug`](#i.plug)

#### Signals

| Signal Name | Valid Values | PO num |
| ----------- | ------------ | ------ |
| `state`     | `1` if light is on, else `0` | |
| `power`     | The current power usage of the plug load | |

#### Slots

| Slot Name | Valid Values | PO num |
| ----------- | ------------ | ----- |
| `state`     | `1` to enable plug. `0` to disable plug | |

---

### Meter

---

### Sensor
