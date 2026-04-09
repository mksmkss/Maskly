import Foundation

public struct DefaultMaskPolicy: MaskPolicy, Sendable {
    public let style: MaskStyle

    public init(style: MaskStyle) {
        self.style = style
    }

    public func mask(_ text: String, category: SensitiveCategory) -> String {
        switch style {
        case .full:
            return String(repeating: "*", count: max(4, text.count))
        case .categoryLabel:
            return category.labelToken
        case .partial:
            return partialMask(text, category: category)
        }
    }

    private func partialMask(_ text: String, category: SensitiveCategory) -> String {
        switch category {
        case .apiKey, .token, .urlSecretParam:
            return maskTokenLike(text)
        case .email:
            return maskEmail(text)
        case .phone:
            return maskPhone(text)
        case .personName, .companyName:
            return String(repeating: "*", count: max(2, text.count))
        }
    }

    private func maskTokenLike(_ text: String) -> String {
        guard text.count > 8 else {
            return String(repeating: "*", count: max(4, text.count))
        }

        let preservedPrefix = tokenPrefix(in: text)
        let suffixCount = min(4, max(0, text.count - preservedPrefix.count))
        let suffix = String(text.suffix(suffixCount))
        let maskedCount = max(4, text.count - preservedPrefix.count - suffixCount)
        return preservedPrefix + String(repeating: "*", count: maskedCount) + suffix
    }

    private func tokenPrefix(in text: String) -> String {
        let knownPrefixes = [
            "sk-proj-", "sk-", "pk_live_", "pk_test_", "sk_live_", "sk_test_",
            "ghp_", "gho_", "ghu_", "ghs_", "ghr_", "AKIA",
        ]

        if let prefix = knownPrefixes.first(where: { text.hasPrefix($0) }) {
            return prefix
        }

        return String(text.prefix(4))
    }

    private func maskEmail(_ text: String) -> String {
        let parts = text.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false)
        guard parts.count == 2 else {
            return String(repeating: "*", count: max(4, text.count))
        }

        let local = String(parts[0])
        let domain = String(parts[1])
        let visible = local.prefix(1)
        let masked = String(repeating: "*", count: max(3, local.count - visible.count))
        return "\(visible)\(masked)@\(domain)"
    }

    private func maskPhone(_ text: String) -> String {
        var digitsToKeep = 4
        var reversedCharacters: [Character] = []

        for character in text.reversed() {
            guard character.isNumber else {
                reversedCharacters.append(character)
                continue
            }

            if digitsToKeep > 0 {
                reversedCharacters.append(character)
                digitsToKeep -= 1
            } else {
                reversedCharacters.append("*")
            }
        }

        return String(reversedCharacters.reversed())
    }
}
