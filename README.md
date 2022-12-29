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

## Installation

Simply add the package as a dependency in `Package.swift`:

```swift
.package(url: "https://github.com/christophhagen/Daly-Swift", from: "0.9.0")
```

## Additions to the library

This library implements only the functionality that I could find publicly available. If you have additional information about other features, especially the ability to set parameters, please let me know, or contribute to this library.

## License

[MIT](License.md)

