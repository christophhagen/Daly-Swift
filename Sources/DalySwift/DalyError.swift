import Foundation

public enum DalyError: Error {
    case failedToCreateSerialClient
    case portClosed
    case invalidResponseLength
    case crcMismatch
    case headerMismatch
    case incompleteFrames
    case failedToTransmitRequest
}
