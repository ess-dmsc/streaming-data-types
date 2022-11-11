# Streaming Data Types

[![DOI](https://zenodo.org/badge/81330954.svg)](https://zenodo.org/badge/latestdoi/81330954)

FlatBuffers is the format chosen for the ESS messaging system.

We would like to be able to read any message in the system at any time,
therefore:

All schemas that we use for the transmission of data are collected in this
repository.

The names of the schema files in this repository are prefixed by their unique
4-character `file_identifier`.  This `file_identifier` must be set in the
schema definition file as:
```
file_identifier = "abcd";
```

The file identifiers (also called "schema id") must be unique on the network. When creating a new schema generate a random one using [this webpage](https://www.random.org/strings/?num=1&len=4&digits=on&upperalpha=on&loweralpha=on&unique=on&format=html&rnd=new).

Table of schema file identifiers follows later in this README. Please add your own (new schema) with file identifier to that table.


## Backwards compatibility

Please, avoid changes which break binary compatibility. FlatBuffers documentation contains good information about how to maintain binary compatibility. If you need to make breaking changes to schemas that are not under development, acquire a new schema id.

Schemas that are under development should be clearly marked as such in the schema file and in the **Schema ids** below to warn users of possible loss of backwards compatibility.

## Not enough file identifiers available?

If you feel that you may need a lot of schema ids, you can use a single schema
and work with the flat buffers union data type in your root element.


## Schema coding standard

* Completely new schemas should have an ID comprising of two characters plus 00, e.g. hs00
* When updating an existing schema with a breaking change then the new schema should have the same ID but with the number incremented, e.g. hs00 -> hs01
  * For older schema which don't end with two numbers, propose a new name which matches the convention.
* Prefix your schema files in this repository with the chosen schema id to more easily prevent id collision.
* Tables should use *UpperCamelCase*.
* Fields should use *snake_case*.
* Try to keep names consistent with equivalent fields in existing schema, e.g.:
  * `timestamp` for timestamp
  * `source_name` for a string indicating origin/source of data in flatbuffer
  * `service_id` for a string indicating the name of the service that created the flatbuffer
* Do not use unsigned integers unless required for your application.


## Schema ids
| ID   | File name                        | Description                                                          |
|------|----------------------------------|----------------------------------------------------------------------|
| f140 | `f140_general.fbs              ` | [OBSOLETE] Can encode an arbitrary EPICS PV
| f141 | `f141_ntarraydouble.fbs        ` | [OBSOLETE] A simple array of double, testing file writing
| f142 | `f142_logdata.fbs              ` | For log data, for example forwarded EPICS PV update [superseded by f144]
| f143 | `f143_structure.fbs            ` | [OBSOLETE] Arbitrary nested data
| f144 | `f144_logdata.fbs              ` | Controls related log data, typically from EPICS or NICOS
| ev42 | `ev42_events.fbs               ` | Multi-institution neutron event data for a single pulse
| ev43 | `ev43_events.fbs               ` | Multi-institution neutron event data from multiple pulses
| ev44 | `ev44_events.fbs               ` | Multi-institution neutron event data for both single and multiple pulses
| is84 | `is84_isis_events.fbs          ` | ISIS specific addition to event messages
| ba57 | `ba57_run_info.fbs             ` | [OBSOLETE] Run start/stop information for Mantid [superseded by pl72]
| df12 | `df12_det_spec_map.fbs         ` | Detector-spectrum map for Mantid
| senv | `senv_data.fbs                 ` | (DEPRECATED) Used for storing for waveforms from DG ADC readout system.
| se00 | `se00_data.fbs                 ` | Used for storing arrays with optional timestamps, for example waveform data. Replaces _senv_. 
| NDAr | `NDAr_NDArray_schema.fbs       ` | (DEPRECATED) Holds binary blob of data with n dimensions
| ADAr | `ADAr_area_detector_array.fbs  ` | Holds EPICS area detector array data (in a flatbuffer format)
| mo01 | `mo01_nmx.fbs                  ` | Daquiri monitor data: pre-binned histograms, raw hits and NMX tracks
| ns10 | `ns10_cache_entry.fbs          ` | NICOS cache entry
| ns11 | `ns11_typed_cache_entry.fbs    ` | NICOS cache entry with typed data
| hs00 | `hs00_event_histogram.fbs      ` | Event histogram stored in n dim array
| hs01 | `hs01_event_histogram.fbs      ` | Event histogram stored in n dim array
| dtdb | `dtdb_adc_pulse_debug.fbs      ` | Debug fields that can be added to the ev42 schema
| ep00 | `ep00_epics_connection_info.fbs` | (DEPRECATED) Status of the EPICS connection
| ep01 | `ep01_epics_connection.fbs  `    | Status or event of EPICS connection. Replaces _ep00_
| json | `json_json.fbs                 ` | Carries a JSON payload
| tdct | `tdct_timestamps.fbs           ` | Timestamps from a device (e.g. a chopper)
| pl72 | `pl72_run_start.fbs            ` | File writing, run start message for file writer and Mantid
| 6s4t | `6s4t_run_stop.fbs             ` | File writing, run stop message for file writer and Mantid
| answ | `answ_action_response.fbs      ` | Holds the result of a command to the filewriter
| wrdn | `wrdn_finished_writing.fbs     ` | Message from the filewriter when it is done writing a file
| x5f2 | `x5f2_status.fbs               ` | Status update and heartbeat message for any software
| rf5k | `rf5k_forwarder_config.fbs     ` | Configuration update for Forwarder
| al00 | `al00_alarm.fbs                ` | Generic alarm schema for EPICS, NICOS, etc.


## Useful information:

- [Have CMake download and compile schema](documentation/cmakeCompileSchema.md)
- [Time formats we use and how to convert between them](documentation/timestamps.md)
