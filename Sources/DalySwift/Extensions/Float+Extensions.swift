import Foundation

extension Float {

    /**
     Create a value from two bytes.
     - Parameter high: The byte treated as the MSB
     - Parameter low: The byte treated as the LSB
     */
    init(high: UInt8, low: UInt8) {
        let raw = UInt16(high: high, low: low)
        self = Float(raw)
    }

    /**
     Create a float from two bytes with a scaling factor.
     - Parameter high: The byte treated as the MSB
     - Parameter low: The byte treated as the LSB
     - Parameter scale: The factor to multiply with the raw number
     */
    init(high: UInt8, low: UInt8, scale: Float) {
        self = Float(high: high, low: low) * scale
    }

    /**
     Create a float from two bytes with an offset.
     - Parameter high: The byte treated as the MSB
     - Parameter low: The byte treated as the LSB
     - Parameter offset: The offset to subtract (before scaling)
     - Parameter scale: The factor to multiply with the raw (and shifted) number
     */
    init(high: UInt8, low: UInt8, offset: Float, scale: Float) {
        self = (Float(high: high, low: low) - offset) * scale
    }

    /**
     Create a float from a raw byte with an offset.
     - Parameter raw: The raw byte, treated as an unsigned number
     - Parameter offset: The offset to subtract
     */
    init(raw: UInt8, offset: Float) {
        self = Float(raw) - offset
    }
}

private extension UInt16 {

    /**
     Create a value from two bytes.
     - Parameter high: The byte treated as the MSB
     - Parameter low: The byte treated as the LSB
     */
    init(high: UInt8, low: UInt8) {
        self = (UInt16(high) << 8) + UInt16(low)
    }
}
