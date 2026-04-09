@testable import MaskliCore
import Testing

@Test
func detectsVendorSpecificSecretsAndMasksThem() {
    let detector = RuleBasedDetector()
    let text = """
    openai=sk-proj-abcdefghijklmnopqrstuvwxyz123456
    github=ghp_abcdefghijklmnopqrstuvwxyz123456
    stripe=sk_test_abcdefghijklmnopqrstuvwxyz
    supabase=sb_publishable_abcdefghijklmnopqrstuvwxyz123456
    aws=AKIA1234567890ABCD12
    """

    let matches = detector.detect(in: text)

    #expect(matches.contains(where: { $0.category == .apiKey }))
    #expect(matches.contains(where: { $0.category == .token }))
    #expect(matches.count >= 5)
}

@Test
func detectsOnlySecretValueInsideUrlQuery() {
    let detector = RuleBasedDetector()
    let text = "https://example.com/callback?token=super-secret-value-12345&mode=prod"

    let matches = detector.detect(in: text)

    #expect(matches.count == 1)
    #expect(String(text[matches[0].range]) == "super-secret-value-12345")
    #expect(matches[0].category == .urlSecretParam)
}

@Test
func doesNotTreatRandomLongWordAsToken() {
    let detector = RuleBasedDetector()
    let text = "abcdefghijklmnopqrstuvwxyz1234567890"

    let matches = detector.detect(in: text)

    #expect(matches.isEmpty)
}

@Test
func detectsEmailAddresses() {
    let detector = RuleBasedDetector()
    let text = "Reach me at alice.smith+demo@example.com"

    let matches = detector.detect(in: text)

    #expect(matches.count == 1)
    #expect(matches[0].category == .email)
    #expect(String(text[matches[0].range]) == "alice.smith+demo@example.com")
}

@Test
func detectsMultipleSensitiveValuesInOneClipboardEntry() {
    let detector = RuleBasedDetector()
    let text = "Email alice@example.com and call +81 90-1234-5678 with token=supersecretvalue0000"

    let matches = detector.detect(in: text)

    #expect(matches.contains(where: { $0.category == .email }))
    #expect(matches.contains(where: { $0.category == .phone }))
    #expect(matches.contains(where: { $0.category == .token }))
    #expect(matches.count == 3)
}
