import Foundation

public struct NormalizedEntityCandidate: Equatable, Sendable {
    public let rawValue: String
    public let normalizedValue: String
    public let similarityScore: Double
    public let source: String

    public init(rawValue: String, normalizedValue: String, similarityScore: Double, source: String) {
        self.rawValue = rawValue
        self.normalizedValue = normalizedValue
        self.similarityScore = similarityScore
        self.source = source
    }
}
