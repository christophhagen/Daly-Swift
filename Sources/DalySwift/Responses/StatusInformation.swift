import Foundation

/**
 The BMS status and configuration.
 */
public struct StatusInformation {

    /** The number of cells connected to the BMS */
    public let cellCount: Int

    /** The number of temperature sensors connected to the BMS */
    public let temperatureSensorCount: Int

    public let chargerIsConnected: Bool

    public let loadIsConnected: Bool

    public let di1: Bool
    public let di2: Bool
    public let di3: Bool
    public let di4: Bool

    public let do1: Bool
    public let do2: Bool
    public let do3: Bool
    public let do4: Bool

}

extension StatusInformation: SingleFrameResponse {

    static let command: Command = .status
    
    /**
     Create the response from the received payload.
     - Parameter bytes: The payload (8 bytes)
     */
    init(bytes: [UInt8]) {
        self.cellCount = Int(bytes[0])
        self.temperatureSensorCount = Int(bytes[1])
        self.chargerIsConnected = bytes[2] > 0
        self.loadIsConnected = bytes[3] > 0
        let byte5 = bytes[4]
        self.di1 = byte5 & 0x01 > 0
        self.di2 = byte5 & 0x02 > 0
        self.di3 = byte5 & 0x04 > 0
        self.di4 = byte5 & 0x08 > 0
        self.do1 = byte5 & 0x10 > 0
        self.do2 = byte5 & 0x20 > 0
        self.do3 = byte5 & 0x40 > 0
        self.do4 = byte5 & 0x80 > 0
    }
}

extension StatusInformation: Equatable {
    
}
