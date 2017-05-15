# Timestamps

**Time format**|**Example of where used**|**Explanation of format**|**Type (flatbuffers)**
:-----:|:-----:|:-----:|:-----:
Nanoseconds past epoch|Event schema|Nanoseconds since Unix epoch (1 Jan 1970), requires 64 bit integer|ulong
ISO 8601|NeXus files|https://en.wikipedia.org/wiki/ISO\_8601, UTC for NeXus|string
EPICS timestamp|EPICS PVs|Struct of seconds since 1 Jan 1990 and nanoseconds past that|stuct (ulong, int)

## Example conversions

### `nanoseconds past epoch` to `ISO 8601`

Python:
```python
def nanoseconds_to_iso8601(nanoseconds):
    dt = datetime.datetime.fromtimestamp(nanoseconds / 1e9)
    return '{}{:03.0f}'.format(dt.strftime('%Y-%m-%dT%H:%M:%SZ%f'), nanoseconds % 1e3)
```

### `EPICS timestamp` to `nanoseconds past epoch`

C++:
```cpp
uint64_t epicsToNanosecsPastEpoch(uint64_t epicsSeconds, int32_t epicsNanoseconds) {
  // You must be explicit about type here (hence the "L" suffix) or C++ will happily
  // convert your constants to double, which will mess up the calculation.
  std::uint64_t unixSeconds = epicsSeconds + 631152000L;
  std::uint64_t nanosecondsPastEpoch = (unixSeconds * 1000000000L) + epicsNanoseconds;
  return nanosecondsPastEpoch;
}
```
