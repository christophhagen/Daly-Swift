import Foundation

/**
 The status of the charge and discharge MOSFETs.
 */
public struct MosfetStatus {

    public enum Status: UInt8 {
        case stationary = 0
        case charging = 1
        case discharding = 2
    }

    /**
     The overall charge/discharge state of the device.
     */
    public let status: Status

    /**
     The status of the charge mosfet.
     */
    public let chargeMosfetStatus: UInt8

    /**
     The status of the discharge mosfet.
     */
    public let dischargeMosfetStatus: UInt8

    /** BMS life (0-255 cycles) */
    public let bmsHeartbeat: UInt8

    /** The remaining capacity (mAh) */
    public let remainingCapacity: UInt32
}

extension MosfetStatus: SingleFrameResponse {

    static let command: Command = .mosfetStatus

    /**
     Create the response from the received payload.
     - Parameter bytes: The payload (8 bytes)
     */
    init(bytes: [UInt8]) {
        self.status = .init(rawValue: bytes[0])!
        self.chargeMosfetStatus = bytes[1]
        self.dischargeMosfetStatus = bytes[2]
        self.bmsHeartbeat = bytes[3]
        self.remainingCapacity = .init(bytes[4...7])
    }
}

extension MosfetStatus: Equatable {

}
