import Foundation

public enum ClientId: RawRepresentable {

    /**
     `0x20`

     This is sometimes referred to as `GPRS` or as `Bluetooth App`.
    */
    case address0x20

    /**
     `0x40`

     This is sometimes referred to as `upper computer` or as `GPRS`.
     */
    case address0x40

    /**
     `0x80`

     This is sometimes referred to as `Bluetooth App` or as `Upper`.
     */
    case address0x80

    /**
     Set a custom address
     */
    case custom(UInt8)

    public var rawValue: UInt8 {
        switch self {
        case .address0x20: return 0x20
        case .address0x40: return 0x40
        case .address0x80: return 0x80
        case .custom(let value): return value
        }
    }

    public init(rawValue: UInt8) {
        switch rawValue {
        case 0x20: self = .address0x20
        case 0x40: self = .address0x40
        case 0x80: self = .address0x80
        default: self = .custom(rawValue)
        }
    }

}
