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

Please, avoid changes which break binary compatibility.  Flatbuffers documentation contains
good information about how to maintain binary compatibility.
If you need to make breaking changes, acquire a new schema id.


## Not enough file identifiers available?

If you feel that you may need a lot of schema ids, you can use a single schema
and work with the flat buffers union data type in your root element.


## Naming

Please prefix your schema files in this repository with your chosen schema id
so that we can easily avoid id collisions.


## Schema ids

```
ID (hex)      Flatbuffer schema file name

0xf140        f140-general.fbs
0xf141        f141-ntarraydouble.fbs
```
