import Foundation
import SwiftSerial

/**
 A client to request information from a Daly BMS.
 */
public class DalyClient {

    private let startByte: UInt8 = 0xA5

    /// The id of the BMS (default: `0x01`)
    public let bmsAddress: UInt8

    private let frameLength = 13

    private let client: SerialPort

    private let connection: ConnectionType = .uart

    private var cellCount: Int?

    private var cellTemperatureCount: Int?

    /**
     Create a client.
     - Parameter path: The path to the serial port where the BMS is connected.
     - Parameter bmsAddress: The id of the BMS (default: `0x01`)
     */
    public init(path: String, bmsAddress: UInt8 = 0x01) {
        self.client = SerialPort(path: path)
        self.bmsAddress = bmsAddress
    }

    /**
     Open the connection to the device.

     - Note: Most parameters should remain on the default setting.
     - Parameter baudRate: The baud rate of the connection (default: 9600)
     - Parameter timeout: The timeout for receiving and transmitting information. A value of `0` will make the connection wait indefinitely.
     - Parameter parity: The parity setting for the connection
     - Parameter dataBits: The number of data bits (default: `8`)
     - Parameter stopBits: The number of stop bits (default: `one`)
     */
    public func open(baudRate: BaudRate = .baud9600, timeout: Int = 1, parity: Parity = .none, dataBits: DataBits = .eight, stopBits: StopBits = .one) async throws {
        try await client.open(
            receiveRate: baudRate,
            transmitRate: baudRate,
            minimumBytesToRead: 0,
            timeout: timeout,
            parity: parity,
            stopBits: stopBits,
            dataBits: dataBits)
    }

    /**
     Create the bytes to transmit in a request.
     */
    private func createRequestData(command: Command) -> [UInt8] {
        let header = [startByte, connection.rawValue, command.byte]
        let payload: [UInt8] = [0x00, 0x00, 0x00, 0x00,
                                0x00, 0x00, 0x00, 0x00]
        let payloadLength = UInt8(payload.count)
        let data = header + [payloadLength] + payload
        let checksum: UInt8 = data.crc()
        return data + [checksum]
    }

    /**
     Send a request and expect multiple frames as the response.
     */
    private func requestFrames(_ command: Command, timeout: TimeInterval) async throws -> [[UInt8]] {
        let requestData = createRequestData(command: command)
        let expectedResponseLength = command.frameCount * frameLength
        // Send request to BMS
        guard try await client.writeBytes(requestData) == requestData.count else {
            throw DalyError.failedToTransmitRequest
        }
        let responseData = try await client.readBytesBlocking(count: expectedResponseLength, timeout: timeout)

        do {
            let frames = try (0..<command.frameCount).map { i in
                let start = i * frameLength
                let end = start + frameLength - 1
                guard end < responseData.count else {
                    print("Frame \(i) ends at \(end), but only \(responseData.count) bytes read")
                    throw DalyError.invalidResponseLength
                }
                let frameData = Array(responseData[start...end])
                return try extractBMSFrame(frameData)
            }
            for frame in frames {
                if frame.command != command.code {
                    print("Received frame has command \(frame.command.rawValue), not \(command.code.rawValue)")
                    throw DalyError.incompleteFrames
                }
            }
            return frames.map { $0.payload }
        } catch {
            // Read all bytes to reset the client
            _ = try await client.readBytes(count: 100)
            throw error
        }
    }

    /**
     Send a request and expect a single response frame
     */
    private func requestFrame(_ command: Command, timeout: TimeInterval) async throws -> [UInt8] {
        try await requestFrames(command, timeout: timeout).first!
    }

    /**
     Send a request and transform the received response frame to a type.
     */
    private func requestFrame<T>(timeout: TimeInterval) async throws -> T where T: SingleFrameResponse {
        let frame = try await requestFrame(T.command, timeout: timeout)
        return .init(bytes: frame)
    }

    /**
     Extract received data from the BMS into a frame.
     */
    private func extractBMSFrame(_ data: [UInt8]) throws -> (command: Command.Code, payload: [UInt8]) {
        let frame = try extractFrame(data)
        guard frame.address == bmsAddress else {
            throw DalyError.headerMismatch
        }
        return (frame.command, frame.payload)
    }

    /**
     Extract received data into a frame.
     */
    private func extractFrame(_ data: [UInt8]) throws -> (command: Command.Code, address: UInt8, payload: [UInt8]) {
        guard data.count == frameLength else {
            print("Expected frame with size \(frameLength), but only got \(data.count)")
            throw DalyError.invalidResponseLength
        }
        let crc = data[0..<frameLength-1].crc()
        guard crc == data.last! else {
            throw DalyError.crcMismatch
        }
        let payloadLength = data.count - 5 // 4 byte header + 1 byte checksum
        guard data[0] == startByte,
              let command = Command.Code(rawValue: data[2]),
              data[3] == payloadLength else {
            throw DalyError.headerMismatch
        }
        return (command: command, address: data[1], payload: Array(data[4...]))
    }

    /**
     Get information about the state of charge, current and voltage.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An object with the requested information
     */
    public func getStateOfCharge(timeout: TimeInterval = 1.0) async throws -> StateOfCharge {
        try await requestFrame(timeout: timeout)
    }

    /**
     Get information about the minimum and maximum voltages.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An object with the requested information
     */
    public func getCellVoltageLimits(timeout: TimeInterval = 1.0) async throws -> CellVoltageLimits {
        try await requestFrame(timeout: timeout)
    }

    /**
     Get information about the minimum and maximum cell temperatures.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An object with the requested information
     */
    public func getCellTemperatureLimits(timeout: TimeInterval = 1.0) async throws -> CellTemperatureLimits {
        try await requestFrame(timeout: timeout)
    }

    /**
     Get information about the state of the charge and discharge MOSFETs.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An object with the requested information
     */
    public func getMosfetStatus(timeout: TimeInterval = 1.0) async throws -> MosfetStatus {
        try await requestFrame(timeout: timeout)
    }

    /**
     Get information about the device status and configuration.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An object with the requested information
     */
    public func getStatus(timeout: TimeInterval = 1.0) async throws -> StatusInformation {
        let status: StatusInformation = try await requestFrame(timeout: timeout)
        self.cellTemperatureCount = status.temperatureSensorCount
        self.cellCount = status.cellCount
        return status
    }

    private func getCellCount(timeout: TimeInterval) async throws -> Int {
        if let cellCount {
            return cellCount
        }
        let status = try await getStatus(timeout: timeout)
        return status.cellCount
    }

    private func getCellTemperatureCount(timeout: TimeInterval) async throws -> Int {
        if let cellTemperatureCount {
            return cellTemperatureCount
        }
        let status = try await getStatus(timeout: timeout)
        return status.temperatureSensorCount
    }

    /**
     Get information about the cell voltages.
     - Note: The request requires knowledge about the cell count. This information is contained in a status response.
     If `getStatus()` has not been called before this function, then a `status` request is performed before requesting the cell voltages.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An array of voltages (Unit: Volt) for each cell in order.
     */
    public func getCellVoltages(timeout: TimeInterval = 1.0) async throws -> [Float] {
        let cellCount = try await getCellCount(timeout: timeout)
        let frames = try await requestFrames(.cellVoltages(count: cellCount), timeout: timeout)

        let voltageData = try decodeMultipleFramesWithFrameId(frames)
            .reduce([]) { $0 + $1[0...5] }
            .prefix(cellCount * 2)

        guard voltageData.count == cellCount * 2 else {
            print("Missing cell voltage data: Only \(voltageData.count) bytes for \(cellCount) items")
            throw DalyError.incompleteFrames
        }
        return (0..<cellCount).map {
            Float(high: voltageData[$0*2], low: voltageData[$0*2+1], scale: 0.001)
        }
    }

    /**
     Get information about the cell temperatures.
     - Note: The request requires knowledge about the temperature sensor count. This information is contained in a status response.
     If `getStatus()` has not been called before this function, then a `status` request is performed before requesting the cell temperatures.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An array of temperatures (Unit: °C) for each sensor in order.
     */
    public func getCellTemperatures(timeout: TimeInterval = 1.0) async throws -> [Float] {
        let cellTemperatureCount = try await getCellTemperatureCount(timeout: timeout)
        let frames = try await requestFrames(.temperatures(count: cellTemperatureCount), timeout: timeout)

        let temperatures = try decodeMultipleFramesWithFrameId(frames)
            .reduce([], +)
            .prefix(cellTemperatureCount)
            .map {
                Float(raw: $0, offset: 40)
            }

        guard temperatures.count == cellTemperatureCount else {
            print("Missing temperatures, expected \(cellTemperatureCount) but only got \(temperatures.count)")
            throw DalyError.incompleteFrames
        }
        return temperatures
    }

    /**
     Get information about the balance state of all cells.
     - Note: The request requires knowledge about the cell count. This information is contained in a status response.
     If `getStatus()` has not been called before this function, then a `status` request is performed before requesting the balance states.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An array of balance states (`true`:  open, `false`: closed) for each cell in order.
     */
    public func getCellBalanceState(timeout: TimeInterval = 1.0) async throws -> [Bool] {
        let cellCount = try await getCellCount(timeout: timeout)
        let frame = try await requestFrame(.balanceStates, timeout: timeout)

        guard frame.count * 8 >= cellCount else {
            // This should never happen, since we check the length of the frame before calling this function
            print("Missing balance states, frame only has \(frame.count) bytes")
            throw DalyError.invalidResponseLength
        }
        return (0..<cellCount).map {
            (frame[$0 / 8] >> ($0 % 8)) & 0x01 > 0
        }
    }

    /**
     Get information about potential failures of the BMS.
     - Parameter timeout: The amount of time to wait for the response.
     - Throws: `DalyError` errors
     - Returns: An object with the requested information
     */
    public func getFailures(timeout: TimeInterval = 1.0) async throws -> FailureStatus {
        try await requestFrame(timeout: timeout)
    }

    private func decodeMultipleFramesWithFrameId(_ frames: [[UInt8]]) throws -> [[UInt8]] {
        // Extract frame id from first byte
        return try frames.map { frame in
            return (id: frame[0], data: Array(frame.dropFirst()))
        }
        .sorted { $0.id < $1.id }
        .enumerated().map { id, frame in
            // Check that all frames are present
            // Note: Documentation claims that frame ids start at 0,
            // but in reality they start at 1
            if frame.id != id + 1 {
                print("Missing frame \(id), got \(frame.id)")
                throw DalyError.incompleteFrames
            }
            return frame.data
        }
    }
}

private extension Collection where Element == UInt8 {

    func crc() -> UInt8 {
        reduce(0) { $0 &+ $1 }
    }
}
