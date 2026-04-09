import Foundation

public struct TextPreprocessor: Sendable {
    public init() {}

    public func preprocess(_ text: String) -> String {
        let normalized = text.precomposedStringWithCanonicalMapping
        let scalars = normalized.unicodeScalars.map { scalar in
            switch scalar.value {
            case 0x3000:
                return UnicodeScalar(0x20)!
            case 0xFF01...0xFF5E:
                return UnicodeScalar(scalar.value - 0xFEE0)!
            default:
                return scalar
            }
        }

        return String(String.UnicodeScalarView(scalars))
    }
}
