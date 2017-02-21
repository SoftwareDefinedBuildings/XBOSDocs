# Driver Conventions

## Driver URI Terminals

When writing a driver, thought must be given as to how to decompose a driver's functionality. There are several levels of decomposition in a driver:

* **Service Name**: typically vendor or device specific, e.g. "s.lifx", "s.venstar"
* **Interface Name**: a standard XBOS interface name, describing a generic function of the device, e.g. "i.light", "i.thermostat"
* **Signals and Payload Contents**: what is actually published by the driver

Choosing the signals and the payload contents requires some thought. There are a few options

### Timeseries Approach

Each signal on an interface is an individual timeseries, with the payload objects being very simple: just the published value and an optional timestamp. The timestamp may be needed for drivers where data must be aligned (e.g. relative humidity and temperature readings)

Example URIs for a Thermostat:

```
s.venstar/LivingRoom/i.thermostat/signal/temperature
    {
        Value: 76.3,
        Time: 123456789,
    }
s.venstar/LivingRoom/i.thermostat/signal/relative_humidity
    {
        Value: 40.1
        Time: 123456789,
    }
s.venstar/LivingRoom/i.thermostat/signal/heating_setpoint
    {
        Value: 74,
        Time: 123456789,
    }
s.venstar/LivingRoom/i.thermostat/signal/cooling_setpoint
    {
        Value: 80,
        Time: 123456789,
    }
```

Pros:
* can attach metadata to individual timeseries
* can use general logic for pulling data out of subscriptions

Cons:
* "fanout" can cause a lot of URIs/messages to be published (example: Venstar driver has ~15 signals per thermostat. Deployment with 5 thermostats has 75 URIs publishing)

### Composite Paylod


