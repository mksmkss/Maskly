import Foundation

public struct ContextualDetector: SensitiveDetector {
    public init() {}

    public func detect(in text: String) -> [SensitiveMatch] {
        _ = text
        return []
    }
}
