@testable import MaskliCore
import Testing

@Test
func partialMaskKeepsEmailDomain() {
    let policy = DefaultMaskPolicy(style: .partial)
    let masked = policy.mask("alice@example.com", category: .email)

    #expect(masked == "a****@example.com")
}

@Test
func partialMaskKeepsTokenPrefixAndSuffix() {
    let policy = DefaultMaskPolicy(style: .partial)
    let masked = policy.mask("ghp_abcdefghijklmnopqrstuvwxyz123456", category: .token)

    #expect(masked.hasPrefix("ghp_"))
    #expect(masked.hasSuffix("3456"))
    #expect(masked.contains("*"))
}

@Test
func categoryLabelStyleUsesCategoryTag() {
    let policy = DefaultMaskPolicy(style: .categoryLabel)
    let masked = policy.mask("sk-proj-abcdefghijklmnopqrstuvwxyz123456", category: .apiKey)

    #expect(masked == "[API_KEY]")
}
