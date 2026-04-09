import Foundation

public struct TextPreprocessor: Sendable {
    public init() {}

    public func preprocess(_ text: String) -> String {
        let normalized = text.precomposedStringWithCompatibilityMapping
        return normalized.applyingTransform(.fullwidthToHalfwidth, reverse: false) ?? normalized
    }
}
