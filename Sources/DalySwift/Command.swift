import Foundation

enum Command {
    case stateOfCharge
    case cellVoltageLimits
    case cellTemperatureLimits
    case mosfetStatus
    case status
    case cellVoltages(count: Int)
    case temperatures(count: Int)
    case balanceStates
    case failures

    enum Code: UInt8 {
        case stateOfCharge = 0x90
        case cellVoltageLimits = 0x91
        case cellTemperatureLimits = 0x92
        case mosfetStatus = 0x93
        case status = 0x94
        case cellVoltages = 0x95
        case temperatures = 0x96
        case balanceStates = 0x97
        case failures = 0x98
    }

    var code: Code {
        switch self {
        case .stateOfCharge: return .stateOfCharge
        case .cellVoltageLimits: return .cellVoltageLimits
        case .cellTemperatureLimits: return .cellTemperatureLimits
        case .mosfetStatus: return .mosfetStatus
        case .status: return .status
        case .cellVoltages: return .cellVoltages
        case .temperatures: return .temperatures
        case .balanceStates: return .balanceStates
        case .failures: return .failures
        }
    }

    var byte: UInt8 {
        code.rawValue
    }

    var frameCount: Int {
        switch self {
        case .cellVoltages(let count):
            // Only three cell voltages fit in one response frame
            return Int((Float(count) / 3).rounded(.up))
        case .temperatures(let count):
            // Only seven cell voltages fit in one response frame
            return Int((Float(count) / 7).rounded(.up))
        default: return 1
        }
    }

    static func isValid(_ code: UInt8) -> Bool {
        code >= 0x90 && code <= 0x98
    }
}

struct PendingCommand {

    let code: Command.Code

    let timeout: TimeInterval
}
