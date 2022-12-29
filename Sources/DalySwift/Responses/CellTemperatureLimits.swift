import Foundation

/**
 The minimum and maximum temperatures of the cells.
 */
public struct CellTemperatureLimits {

    /** The maximum temperature (°C) */
    public let maximumTemperature: Float

    /** The number of the cell with the maximum temperature */
    public let maximumTemperatureCell: Int

    /** The minimum temperature (°C) */
    public let minimumTemperature: Float

    /** The number of the cell with the minimum temperature */
    public let minimumTemperatureCell: Int
}

extension CellTemperatureLimits: SingleFrameResponse {

    static let command: Command = .cellTemperatureLimits

    /**
     Create the response from the received payload.
     - Parameter bytes: The payload (8 bytes)
     */
    init(bytes: [UInt8]) {
        self.maximumTemperature = .init(raw: bytes[0], offset: 40)
        self.maximumTemperatureCell = Int(bytes[1])
        self.minimumTemperature = .init(raw: bytes[2], offset: 40)
        self.minimumTemperatureCell = Int(bytes[3])
    }
}
