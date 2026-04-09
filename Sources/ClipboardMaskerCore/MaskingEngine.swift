import Foundation

public struct MaskingEngine: Sendable {
    public init() {}

    public func apply(
        to text: String,
        matches: [SensitiveMatch],
        maskPolicy: some MaskPolicy
    ) -> String {
        guard matches.isEmpty == false else { return text }

        let sortedMatches = matches.sorted { $0.nsRange(in: text).location < $1.nsRange(in: text).location }
        var result = ""
        var cursor = text.startIndex

        for match in sortedMatches {
            guard cursor <= match.range.lowerBound else { continue }

            result += text[cursor..<match.range.lowerBound]
            let originalValue = String(text[match.range])
            result += maskPolicy.mask(originalValue, category: match.category)
            cursor = match.range.upperBound
        }

        result += text[cursor...]
        return result
    }
}
