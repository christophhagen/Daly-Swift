import Foundation

/**
 The state of charge, voltage and current.
 */
public struct StateOfCharge {

    /** Cumulative total voltage (V) */
    public let totalVoltage: Float

    /** Gather total voltage (V) */
    public let gatherVoltage: Float

    /** Current (A), negative: charging, positive: discharging */
    public let current: Float

    /** State of Charge (%) */
    public let stateOfCharge: Float
}

extension StateOfCharge: SingleFrameResponse {

    static let command: Command = .stateOfCharge

    /**
     Create the response from the received payload.
     - Parameter bytes: The payload (8 bytes)
     */
    init(bytes: [UInt8]) {
        self.totalVoltage = .init(high: bytes[0], low: bytes[1], scale: 0.1)
        self.gatherVoltage = .init(high: bytes[2], low: bytes[3], scale: 0.1)
        self.current = .init(high: bytes[4], low: bytes[5], offset: 30000, scale: 0.1)
        self.stateOfCharge = .init(high: bytes[6], low: bytes[7], scale: 0.1)
    }
}
