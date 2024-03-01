# DalySwift

A Swift library to communicate with a Daly BMS over RS485/Serial. The library currently only provides reading capabilities, but should implement all publicly known functionality (cell voltages, SoC, temperatures, ...). As far as documented, the received values are converted, scaled, and annotated with information from the documentation. Enums are used wherever appropriate.

## Usage

To communicate with the BMS, first connect it via a serial adapter to the computer. Note the serial port and then:

```swift
import DalySwift

// Create the client
let client = DalyClient(path: "/dev/ttyUSB0")

// Open the port
try await client.open()

// Request information
let status = try await client.getStatus()
let socInfo = try await client.getStateOfCharge()
let voltLim = try await client.getCellVoltageLimits()
let tempLim = try await client.getCellTemperatureLimits()
let mosfets = try await client.getMosfetStatus()
let voltages = try await client.getCellVoltages()
let temps = try await client.getCellTemperatures()
let balance = try await client.getCellBalanceState()

// Use information
let voltageCell1: Float = voltages[0] // In volt
let maxTemperature: Float = tempLim.maximumTemperature // In °C
let isCharging = mosfets.status == .charging
let SoC: Float = socInfo.stateOfCharge // In percent
```

### Multiple devices on one interface

This feature is not currently supported.
The protocol doesn't specify how to address a single device on the bus.
It may be possible that all devices respond to each request, and the received responses have to be checked for the correct BMS id.
In any case, this seems to also require changing the BMS address in the firmware.
As I don't have the required setup, I can't test this behaviour.
If you have any additional information about this topic, please tell me.

If you set a different BMS address, you have to tell the client:

```swift
let client = DalyClient(path: "/dev/ttyUSB0", bmsAddress: 0x02)
```

### Client id

The communication protocol specifies a "Communication module address" sent by the client to the BMS when requesting data.
This id seems to identify the client in some way, and there seem to be a few accepted values (`0x20`, `0x40`, `0x80`).
The available documentation is inconsistent which values to use, and it mostly seems to work with any of the common ones.
Feel free to experiment with this setting, and it's also possible to set a custom value.

```swift
let client = DalyClient(path: "/dev/ttyUSB0", id: .address0x40)
```

## Installation

Simply add the package as a dependency in `Package.swift`:

```swift
.package(url: "https://github.com/christophhagen/Daly-Swift", from: "0.9.0")
```

## Additions to the library

This library implements only the functionality that I could find [publicly available](Docs/DALY-UART%20485%20Communications%20Protocol%20v1.2). If you have additional information about other features, especially the ability to set parameters, please let me know, or contribute to this library.

## License

[MIT](License.md)

