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

The schema ids must be unique on the network.
You can generate a new `file_identifier` by visiting [this webpage](https://www.random.org/strings/?num=1&len=4&digits=on&upperalpha=on&loweralpha=on&unique=on&format=html&rnd=new).

Table of schema file identifiers follows later in this README.

To get your very own file identifier, please just pick one available and
document it here in the README and do upload the schema as well.


## Namespace

Please namespace your schema so that the generated c++ headers do not collide.
Including e.g. the schema id in the namespace name avoids any collision.


## Backwards compatibility

Please, avoid changes which break binary compatibility. FlatBuffers documentation contains good information about how to maintain binary compatibility. If you need to make breaking changes to schemas that are not under development, acquire a new schema id.

Schemas that are under development should be clearly marked as such in the schema file and in the **Schema ids** below to warn users of possible loss of backwards compatibility.

## Not enough file identifiers available?

If you feel that you may need a lot of schema ids, you can use a single schema
and work with the flat buffers union data type in your root element.


## Naming

Please prefix your schema files in this repository with your chosen schema id
so that we can easily avoid id collisions.
Tables should use UpperCamelCase and fields should use snake_case. Try to keep names consistent with equivalent fields in existing schema.


## Schema ids

```
ID            Flatbuffer schema file name

f140        f140_general.fbs                  [OBSOLETE] Can encode an arbitrary EPICS PV
f141        f141_ntarraydouble.fbs            [OBSOLETE] A simple array of double, testing file writing
f142        f142_logdata.fbs                  For log data, for example forwarded EPICS PV update
f143        f143_structure.fbs                [OBSOLETE] Arbitrary nested data
rit0        rit0_psi_sinq_schema.fbs          Neutron event data according the RITA2
ev42        ev42_events.fbs                   Multi-institution neutron event data
is84        is84_isis_events.fbs              ISIS specific addition to event messages
ba57        ba57_run_info.fbs                 [OBSOLETE] Run start/stop information for Mantid [superceded by pl72]
df12        df12_det_spec_map.fbs             Detector-spectrum map for Mantid
ai33        ai33_det_count_imgs.fbs           Accumulated counts of detection events
ai34        ai34_det_counts.fbs               Counts on each detector pixel from a single pulse
senv        senv_data.fbs                     Used for storing for waveforms from DG ADC readout system.
NDAr        NDAr_NDArray_schema.fbs           Holds binary blob of data with n dimensions.
mo01        mo01_nmx.fbs                      Daquiri monitor data: pre-binned histograms, raw hits and NMX tracks.
ns10        ns10_cache_entry.fbs              NICOS cache entry
ns11        ns11_typed_cache_entry.fbs        NICOS cache entry with typed data
hs00        hs00_event_histogram.fbs          Event histogram stored in n dim array
dtdb        dtdb_adc_pulse_debug.fbs          Debug fields that can be added to the ev42 schema
ep00        ep00_epics_connection_info.fbs    Status of the EPICS connection
json        json_json.fbs                     Carries a JSON payload
tdct        tdct_timestamps.fbs               Timestamps from a device (e.g. a chopper)
pl72        pl72_run_start.fbs                File writing, run start message for file writer and Mantid
6s4t        6s4t_run_stop.fbs                 File writing, run stop message for file writer and Mantid
x5f2        x5f2_status.fbs                   Status update and heartbeat message for any software
rf5k        rf5k_forwarder_config.fbs         Configuration update for Forwarder
```

## Useful information:

- [Have CMake download and compile schema](documentation/cmakeCompileSchema.md)
- [Time formats we use and how to convert between them](documentation/timestamps.md)
