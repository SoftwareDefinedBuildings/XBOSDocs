# Standard Key/Value Pairs

### Deployment-level

These keys are applied further up the URI hierarchy so as to apply to all URIs in a deployment

* `Deployment`: The name of a particular deployment site
* `Zipcode`: The zipcode of the deployment site
* `Latitude`: the latitude of the deployment site
* `Longitude`: the longitude of the deployment site

### Driver-level

These keys are applied on a per-driver basis, i.e. at the "root" of the driver's URIs.

* `SourceName`: The name for this instance of a driver
* `Device`: The standard, generic name for this device, e.g. "Thermostat" (a list of these names is provided elsewhere in this documentation)
* `Manufacturer`: The manufacturer of the device, or publisher of the underlying service (e.g. `Siemens` or `Weather Underground`)
* `Model`: The model number of the device, if known

### Timeseries-level

These keys are applied to each terminal URI of a driver to describe the data published on that URI

* `UnitofMeasure`: engineering units for the stream
* `Type`: The standard, generic name for this timeseries (a list of these names is provided elsewhere in this documentation)
* `_name`: vendor-name for the stream
