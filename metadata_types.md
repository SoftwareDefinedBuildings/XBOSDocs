# Types of Metadata

There are 2 types of metadata in XBOS, but it is important that they work together.

1. **Driver Metadata**: this are key-value pairs attached to BOSSWAVE URIs that are the endpoints for deployed BOSSWAVE drivers and services. This metadata primarily describes the characteristics of the timeseries stream. These key-value pairs should be drawn, where possible, from the [canonical set of XBOS metadata keys](metadata_driver.md). 
2. **Building Metadata**: this is metadata that is not necessarily associated with any specific timeseries stream or BOSSWAVE URI. Rather, it describes the structure of the building or larger deployment. The metadata schema used here is Brick, which is documented at [http://brickschema.org/](http://brickschema.org/)

The next question is: how do these fit together?

Driver metadata 
