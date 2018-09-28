# Device Drivers

### Deploying Drivers
Device drivers are configured and deployed using three files:

- `params.yml`: direct configuration for the driver, such as IP address, user/pass, API key, etc
- `deploy.yml`: Spawnpoint configuration file; contains instructions for building and deploying a service. Details about configuring the spawnpoint service can be found [here](https://github.com/SoftwareDefinedBuildings/spawnpoint). Verify that the spawnpoint daemon's (spawnd's) configuration in ```/etc/spawnd/config.yml``` matches the service's configuration. 
- `archive.yml`: contains instructions on how to parse/archive the BOSSWAVE streams produced by the driver. Details about configuring the archiver can be found [here](https://docs.xbos.io/pundat.html).

To install a driver, run the [XBOS driver.sh install script](https://raw.githubusercontent.com/SoftwareDefinedBuildings/XBOS/master/commissioning/drivers.sh). This will guide you through the various configuration files to set up and deploy a driver:
```bash drivers.sh```
This installation method is under active development.

### Interacting with drivers

When a driver is deployed, it receives a unique URI using which a user can interact with it. More information on how the URIs are usually structured are provided in the [Driver Conventions] (https://docs.xbos.io/driver_conventions.html) document. Documentation about the type of data that can be read from and commands that can be sent to specific drivers can be found under the "DRIVERS" section of this document. Both python and go interfaces for the specific driver types are also provided. 

This is an example of a [XBOS Thermostat Interface](https://docs.xbos.io/example-thermostat-driver-interface.html).

