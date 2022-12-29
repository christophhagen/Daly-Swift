import Foundation

/**
 The minimum and maximum voltages of the cells.
 */
public struct CellVoltageLimits {

    /** The maximum voltage (V) */
    public let maximumVoltage: Float

    /** The number of the cell with the maximum voltage */
    public let maximumVoltageCell: Int

    /** The minimum voltage (V) */
    public let minimumVoltage: Float

    /** The number of the cell with the minimum voltage */
    public let minimumVoltageCell: Int
}

extension CellVoltageLimits: SingleFrameResponse {

    static let command: Command = .cellVoltageLimits

    /**
     Create the response from the received payload.
     - Parameter bytes: The payload (8 bytes)
     */
    init(bytes: [UInt8]) {
        self.maximumVoltage = .init(high: bytes[0], low: bytes[1], scale: 0.001)
        self.maximumVoltageCell = Int(bytes[2])
        self.minimumVoltage = .init(high: bytes[3], low: bytes[4], scale: 0.001)
        self.minimumVoltageCell = Int(bytes[5])
    }
}
