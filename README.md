# Streaming Data Types

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

Table of schema file identifiers follows later in this README.

To get your very own file identifier, please just pick one available and
document it here in the README and do upload the schema as well.


## Namespace

Please namespace your schema so that the generated c++ headers do not collide.
Including e.g. the schema id in the namespace name avoids any collision.


## Backwards compatibility

Please, avoid changes which break binary compatibility. Flatbuffers documentation contains good information about how to maintain binary compatibility. If you need to make breaking changes to schemas that are not under development, acquire a new schema id.

Schemas that are under development should be clearly marked as such in the schema file and in the **Schema ids** below to warn users of possible loss of backwards compatibility.

## Not enough file identifiers available?

If you feel that you may need a lot of schema ids, you can use a single schema
and work with the flat buffers union data type in your root element.


## Naming

Please prefix your schema files in this repository with your chosen schema id
so that we can easily avoid id collisions.


## Schema ids

```
ID            Flatbuffer schema file name

f140        f140_general.fbs          Can encode an arbitrary EPICS PV
f141        f141_ntarraydouble.fbs    A simple array of double, testing file writing
f143        f143_structure.fbs        Arbitrary nested data
rit0        rit0_psi_sinq_schema.fbs  Neutron event data according the RITA2
ev42        ev42_events.fbs           Multi-institution neutron event data
is84        is84_isis_events.fbs      ISIS specific addition to event messages
ba57        ba57_run_info.fbs         Run start/stop information for Mantid
df12        df12_det_spec_map.fbs     Detector-spectrum map for Mantid
ai33        ai33_det_count_imgs.fbs   Accumulated counts of detector events
ifdq        ifdq_ifcdaq_data.fbs      **Under development**
NDAr        NDAr_NDArray_schema.fbs   **Under development**
mo01        mo01_nmx.fbs              **Under development**
cid0        cid0_component_id.fbs     **Under development**  Identify components in system
stat        stat_status.fbs           **Under development**  Container for JSON status messages
```

## Useful information:

- [Have CMake download and compile schema](documentation/cmakeCompileSchema.md)
- [Time formats we use and how to convert between them](documentation/timestamps.md)
