import Foundation

public struct RuleBasedDetector: SensitiveDetector {
    public let rules: [RegexRule]

    public init(rules: [RegexRule] = RuleBasedDetector.defaultRules) {
        self.rules = rules
    }

    public func detect(in text: String) -> [SensitiveMatch] {
        let nsText = text as NSString
        let fullRange = NSRange(location: 0, length: nsText.length)
        let rawMatches = rules.flatMap { rule in
            rule.pattern.matches(in: text, range: fullRange).compactMap { result -> CandidateMatch? in
                let targetRange: NSRange
                if let capture = rule.valueCaptureGroup, capture < result.numberOfRanges {
                    targetRange = result.range(at: capture)
                } else {
                    targetRange = result.range
                }

                guard targetRange.location != NSNotFound,
                      let swiftRange = Range(targetRange, in: text)
                else {
                    return nil
                }

                let value = String(text[swiftRange])
                if let validator = rule.validator, validator(value) == false {
                    return nil
                }

                return CandidateMatch(
                    range: swiftRange,
                    nsRange: targetRange,
                    category: rule.category,
                    confidence: rule.confidence,
                    detectorID: rule.id,
                    priority: rule.priority
                )
            }
        }

        let resolved = resolveOverlaps(rawMatches)
        return resolved.map {
            SensitiveMatch(
                range: $0.range,
                category: $0.category,
                confidence: $0.confidence,
                detectorID: $0.detectorID,
                priority: $0.priority
            )
        }
    }

    private func resolveOverlaps(_ matches: [CandidateMatch]) -> [CandidateMatch] {
        let sorted = matches.sorted {
            if $0.priority != $1.priority { return $0.priority > $1.priority }
            if $0.nsRange.length != $1.nsRange.length { return $0.nsRange.length > $1.nsRange.length }
            return $0.nsRange.location < $1.nsRange.location
        }

        var accepted: [CandidateMatch] = []
        for candidate in sorted where accepted.contains(where: { $0.nsRange.intersects(candidate.nsRange) }) == false {
            accepted.append(candidate)
        }

        return accepted.sorted { $0.nsRange.location < $1.nsRange.location }
    }
}

private struct CandidateMatch {
    let range: Range<String.Index>
    let nsRange: NSRange
    let category: SensitiveCategory
    let confidence: Double
    let detectorID: String
    let priority: Int
}

private extension NSRange {
    func intersects(_ other: NSRange) -> Bool {
        NSIntersectionRange(self, other).length > 0
    }
}

public extension RuleBasedDetector {
    static let defaultRules: [RegexRule] = [
        makeRule(
            id: "openai-api-key",
            category: .apiKey,
            priority: 1_000,
            pattern: #"\bsk-(?:proj-)?[A-Za-z0-9_\-]{20,}\b"#
        ),
        makeRule(
            id: "aws-access-key",
            category: .apiKey,
            priority: 990,
            pattern: #"\bAKIA[0-9A-Z]{16}\b"#
        ),
        makeRule(
            id: "github-token",
            category: .token,
            priority: 980,
            pattern: #"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{20,}\b"#
        ),
        makeRule(
            id: "stripe-key",
            category: .apiKey,
            priority: 970,
            pattern: #"\b(?:sk|pk)_(?:live|test)_[A-Za-z0-9]{16,}\b"#
        ),
        makeRule(
            id: "supabase-key",
            category: .apiKey,
            priority: 965,
            pattern: #"\bsb_[A-Za-z0-9_\-]{16,}\b"#
        ),
        makeRule(
            id: "jwt-token",
            category: .token,
            priority: 950,
            pattern: #"\beyJ[A-Za-z0-9_\-]{8,}\.[A-Za-z0-9_\-]{8,}\.[A-Za-z0-9_\-]{8,}\b"#
        ),
        makeRule(
            id: "assigned-token",
            category: .token,
            priority: 940,
            pattern: #"(?i)\b(?:token|access_token|refresh_token|secret|client_secret|api[_\-]?key)\b\s*[:=]\s*["']?([A-Za-z0-9_\-\.]{16,})["']?"#,
            valueCaptureGroup: 1
        ),
        makeRule(
            id: "url-secret-param",
            category: .urlSecretParam,
            priority: 960,
            pattern: #"(?i)[?&](?:token|key|api_key|access_token|secret|client_secret)=([^&#\s]+)"#,
            valueCaptureGroup: 1
        ),
        makeRule(
            id: "email",
            category: .email,
            priority: 700,
            pattern: #"\b[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}\b"#,
            options: [.caseInsensitive]
        ),
        makeRule(
            id: "phone",
            category: .phone,
            priority: 500,
            pattern: #"(?<![\w@])(?:\+?\d[\d\-\s]{8,}\d)(?![\w@])"#,
            validator: { value in
                let digits = value.filter(\.isNumber)
                return (10...15).contains(digits.count)
            }
        ),
    ]

    private static func makeRule(
        id: String,
        category: SensitiveCategory,
        priority: Int,
        pattern: String,
        valueCaptureGroup: Int? = nil,
        options: NSRegularExpression.Options = [],
        validator: (@Sendable (String) -> Bool)? = nil
    ) -> RegexRule {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return RegexRule(
            id: id,
            category: category,
            priority: priority,
            pattern: regex,
            valueCaptureGroup: valueCaptureGroup,
            validator: validator
        )
    }
}
