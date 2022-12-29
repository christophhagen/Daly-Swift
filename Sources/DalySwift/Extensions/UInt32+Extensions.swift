import Foundation

extension UInt32 {

    init<T>(_ bytes: T) where T: RandomAccessCollection, T.Element == UInt8, T.Index == Int {
        guard bytes.count == 4 else {
            self = 0
            return
        }
        self = UInt32(bytes[bytes.startIndex]) << 24
        self += UInt32(bytes[bytes.startIndex+1]) << 16
        self += UInt32(bytes[bytes.startIndex+2]) << 8
        self += UInt32(bytes[bytes.startIndex+3])
    }
}
