# Streaming Data Types

FlatBuffers is the format chosen for the ESS messaging system.

We would like to be able to read any message in the system at any time.
To that end, each message contains a 16-bit schema identifier in the beginning:

```
| 16-bit schema id | [...payload...] |
```

The schema ids must be unique on the network.

Table of schema ids follows later in this README.


## Namespace

Please namespace your schema so that the generated c++ headers do not collide.
Including e.g. the schema id in the namespace name avoids any collision.


## Backwards compatibility

Please, avoid changes which break binary compatibility.  Flatbuffers documentation contains
good information about how to maintain binary compatibility.
If you need to make breaking changes, acquire a new schema id.


## 16 bit id not enough?

If you feel that you may need many schema ids, you have the following options:

1) Use a single schema but work with the flat buffers union data type in your root element.

2) Add another schema identifier of your choice after the first 16 bits and document your
   format in this README.


## Naming

Please prefix your schema files in this repository with your chosen schema id
so that we can easily avoid id collisions.


## Schema ids

```
ID (hex)      Flatbuffer schema file name

0xf140        f140-general.fbs
0xf141        f141-ntarraydouble.fbs
```



#### Note

This repository contains the flatbuffer structure definition files for messages streamed through Kafka through the ESS data acquisition  system. As this repository essentially contains the interface definitions which make the ESS data aquistion tick, be extra careful when changing anything in here. Please consult any affected parties. Develop in branches.
