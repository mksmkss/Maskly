import Foundation

public struct RegexRule: @unchecked Sendable {
    public let id: String
    public let category: SensitiveCategory
    public let priority: Int
    public let pattern: NSRegularExpression
    public let valueCaptureGroup: Int?
    public let validator: (@Sendable (String) -> Bool)?
    public let confidence: Double

    public init(
        id: String,
        category: SensitiveCategory,
        priority: Int,
        pattern: NSRegularExpression,
        valueCaptureGroup: Int? = nil,
        validator: (@Sendable (String) -> Bool)? = nil,
        confidence: Double = 0.95
    ) {
        self.id = id
        self.category = category
        self.priority = priority
        self.pattern = pattern
        self.valueCaptureGroup = valueCaptureGroup
        self.validator = validator
        self.confidence = confidence
    }
}
