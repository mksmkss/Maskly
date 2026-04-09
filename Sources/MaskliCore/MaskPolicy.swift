import Foundation

public protocol MaskPolicy {
    func mask(_ text: String, category: SensitiveCategory) -> String
}
