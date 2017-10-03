# Device Drivers

Device drivers are configured and deployed using three files:

- `params.yml`: direct configuration for the driver, such as IP address, user/pass, API key, etc
- `deploy.yml`: Spawnpoint configuration file; contains instructions for building and deploying a service
- `archive.yml`: contains instructions on how to parse/archive the BOSSWAVE streams produced by the driver

To install a driver, run the [XBOS driver.sh install script](https://raw.githubusercontent.com/SoftwareDefinedBuildings/XBOS/master/commissioning/drivers.sh). This will guide you through the various configuration files to set up and deploy a driver.

This installation method is under active development.
