import Foundation

public struct SensitiveMatch: Equatable, Sendable {
    public let range: Range<String.Index>
    public let category: SensitiveCategory
    public let confidence: Double
    public let detectorID: String
    public let priority: Int

    public init(
        range: Range<String.Index>,
        category: SensitiveCategory,
        confidence: Double,
        detectorID: String,
        priority: Int
    ) {
        self.range = range
        self.category = category
        self.confidence = confidence
        self.detectorID = detectorID
        self.priority = priority
    }

    public func nsRange(in text: String) -> NSRange {
        NSRange(range, in: text)
    }
}
