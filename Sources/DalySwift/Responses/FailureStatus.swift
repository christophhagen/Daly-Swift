import Foundation

/**
 The status of the BMS regarding failures and fault conditions.
 */
public struct FailureStatus {

    /** The failures of the BMS as an option set */
    public let failures: Failures

    /** The fault code reported from the BMS */
    public let faultCode: UInt8

}

extension FailureStatus: SingleFrameResponse {

    static let command: Command = .failures

    /**
     Create the response from the received payload.
     - Parameter bytes: The payload (8 bytes)
     */
    init(bytes: [UInt8]) {
        self.failures = .init(bytes: bytes)
        self.faultCode = bytes[7]
    }
}

extension FailureStatus {

    /**
     An option set of possible failures.
     */
    public struct Failures: OptionSet {

        public let rawValue: UInt64

        public init(rawValue: UInt64) {
            self.rawValue = rawValue
        }

        public static let cellVoltageHighLevel1 =  Failures(rawValue: 1 << (7 * 8)) // Byte 0, Bit 0
        public static let cellVoltageHighLevel2 =  Failures(rawValue: 1 << (7 * 8 + 1)) // Byte 0, Bit 1
        public static let cellVoltageLowLevel1 =  Failures(rawValue: 1 << (7 * 8 + 2)) // Byte 0, Bit 2
        public static let cellVoltageLowLevel2 =  Failures(rawValue: 1 << (7 * 8 + 3)) // Byte 0, Bit 3
        public static let sumVoltageHighLevel1 =  Failures(rawValue: 1 << (7 * 8 + 4)) // Byte 0, Bit 4
        public static let sumVoltageHighLevel2 =  Failures(rawValue: 1 << (7 * 8 + 5)) // Byte 0, Bit 5
        public static let sumVoltageLowLevel1 =  Failures(rawValue: 1 << (7 * 8 + 6)) // Byte 0, Bit 6
        public static let sumVoltageLowLevel2 =  Failures(rawValue: 1 << (7 * 8 + 7)) // Byte 0, Bit 7

        public static let chargeTemperatureHighLevel1 =  Failures(rawValue: 1 << (6 * 8)) // Byte 1, Bit 0
        public static let chargeTemperatureHighLevel2 =  Failures(rawValue: 1 << (6 * 8 + 1)) // Byte 1, Bit 1
        public static let chargeTemperatureLowLevel1 =  Failures(rawValue: 1 << (6 * 8 + 2)) // Byte 1, Bit 2
        public static let chargeTemperatureLowLevel2 =  Failures(rawValue: 1 << (6 * 8 + 3)) // Byte 1, Bit 3
        public static let dischargeTemperatureHighLevel1 =  Failures(rawValue: 1 << (6 * 8 + 4)) // Byte 1, Bit 4
        public static let dischargeTemperatureHighLevel2 =  Failures(rawValue: 1 << (6 * 8 + 5)) // Byte 1, Bit 5
        public static let dischargeTemperatureLowLevel1 =  Failures(rawValue: 1 << (6 * 8 + 6)) // Byte 1, Bit 6
        public static let dischargeTemperatureLowLevel2 =  Failures(rawValue: 1 << (6 * 8 + 7)) // Byte 1, Bit 7

        public static let chargeOvercurrentLevel1 =  Failures(rawValue: 1 << (5 * 8)) // Byte 2, Bit 0
        public static let chargeOvercurrentLevel2 =  Failures(rawValue: 1 << (5 * 8 + 1)) // Byte 2, Bit 1
        public static let dischargeOvercurrentLevel1 =  Failures(rawValue: 1 << (5 * 8 + 2)) // Byte 2, Bit 2
        public static let dischargeOvercurrentLevel2 =  Failures(rawValue: 1 << (5 * 8 + 3)) // Byte 2, Bit 3
        public static let socHighLevel1 =  Failures(rawValue: 1 << (5 * 8 + 4)) // Byte 2, Bit 4
        public static let socHighLevel2 =  Failures(rawValue: 1 << (5 * 8 + 5)) // Byte 2, Bit 5
        public static let socLowLevel1 =  Failures(rawValue: 1 << (5 * 8 + 6)) // Byte 2, Bit 6
        public static let socLowLevel2 =  Failures(rawValue: 1 << (5 * 8 + 7)) // Byte 2, Bit 7

        public static let diffVoltageLevel1 =  Failures(rawValue: 1 << (4 * 8)) // Byte 3, Bit 0
        public static let diffVoltageLevel2 =  Failures(rawValue: 1 << (4 * 8 + 1)) // Byte 3, Bit 1
        public static let diffTemperatureLevel1 =  Failures(rawValue: 1 << (4 * 8 + 2)) // Byte 3, Bit 2
        public static let diffTemperatureLevel2 =  Failures(rawValue: 1 << (4 * 8 + 3)) // Byte 3, Bit 3

        public static let chargeMosfetTemperatureHighAlarm =  Failures(rawValue: 1 << (3 * 8)) // Byte 4, Bit 0
        public static let dischargeMosfetTemperatureHighAlarm =  Failures(rawValue: 1 << (3 * 8 + 1)) // Byte 4, Bit 1
        public static let chargeMosfetTemperatureError =  Failures(rawValue: 1 << (3 * 8 + 2)) // Byte 4, Bit 2
        public static let dischargeMosfetTemperature =  Failures(rawValue: 1 << (3 * 8 + 3)) // Byte 4, Bit 3
        public static let chargeMosfetAdhesionError =  Failures(rawValue: 1 << (3 * 8 + 4)) // Byte 4, Bit 4
        public static let dischargeMosfetAdhesionError =  Failures(rawValue: 1 << (3 * 8 + 5)) // Byte 4, Bit 5
        public static let chargeMosfetOpenCircuitError =  Failures(rawValue: 1 << (3 * 8 + 6)) // Byte 4, Bit 6
        public static let dischargeMosfetOpenCircuitError =  Failures(rawValue: 1 << (3 * 8 + 7)) // Byte 4, Bit 7

        public static let afeCollectChipError =  Failures(rawValue: 1 << (2 * 8)) // Byte 5, Bit 0
        public static let voltageCollectDropped =  Failures(rawValue: 1 << (2 * 8 + 1)) // Byte 5, Bit 1
        public static let cellTemperatureSensorError =  Failures(rawValue: 1 << (2 * 8 + 2)) // Byte 5, Bit 2
        public static let eepromError =  Failures(rawValue: 1 << (2 * 8 + 3)) // Byte 5, Bit 3
        public static let rtcError =  Failures(rawValue: 1 << (2 * 8 + 4)) // Byte 5, Bit 4
        public static let prechargeFailure =  Failures(rawValue: 1 << (2 * 8 + 5)) // Byte 5, Bit 5
        public static let communicationFailure =  Failures(rawValue: 1 << (2 * 8 + 6)) // Byte 5, Bit 6
        public static let internalCommunicationFailure =  Failures(rawValue: 1 << (2 * 8 + 7)) // Byte 5, Bit 7

        public static let currentModeFault =  Failures(rawValue: 1 << (1 * 8)) // Byte 6, Bit 0
        public static let sumVoltageDetectFault =  Failures(rawValue: 1 << (1 * 8 + 1)) // Byte 6, Bit 1
        public static let shortCircuitProtectFault =  Failures(rawValue: 1 << (1 * 8 + 2)) // Byte 6, Bit 2
        public static let lowVoltageForbiddenChargeFault =  Failures(rawValue: 1 << (1 * 8 + 3)) // Byte 6, Bit 3
    }
}

extension FailureStatus.Failures {

    /**
     Create the response from the received payload.
     - Parameter bytes: The payload (8 bytes)
     */
    init(bytes: [UInt8]) {
        var rawValue = UInt64(bytes[0]) << 56
        rawValue += UInt64(bytes[1]) << 48
        rawValue += UInt64(bytes[2]) << 40
        rawValue += UInt64(bytes[3]) << 32
        rawValue += UInt64(bytes[4]) << 24
        rawValue += UInt64(bytes[5]) << 16
        rawValue += UInt64(bytes[6]) << 8
        self.rawValue = rawValue
    }
}

extension FailureStatus: Equatable {
    
}
