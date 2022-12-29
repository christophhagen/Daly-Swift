import Foundation

protocol SingleFrameResponse {

    init(bytes: [UInt8])

    static var command: Command { get }
}
