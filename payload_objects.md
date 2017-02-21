# Payload Objects

A "PO num" or "PO type" is a 32-bit number describing the format and content of a BOSSWAVE message.

BOSSWAVE has support for [many different types of POs](https://github.com/immesys/bw2_pid), but in the context of XBOS, it is important to decide on an operable subset of these that will ease development.

For drivers part of an XBOS deployment, there are two primary modes of interaction:

* **Reporting**: drivers publishing their data. The necessary fields here are the *value* being published, and also the *time* that value was published. Generating the timestamp on the device side allows for the alignment of multiple fields. For example, a relative humidity reading is valid at a given temperature; if the device measures both simultaneously, then this should be reflected in the reported messages. The majority of reported values will be numerical timeseries

* **Actuating**: drivers receiving actuation commands. 
