@testable import ClipboardMaskerCore
import Testing

@Test
func maskingEngineReplacesSensitiveRangesInDescendingOrder() {
    let detector = RuleBasedDetector()
    let policy = DefaultMaskPolicy(style: .partial)
    let engine = MaskingEngine()
    let text = "Contact alice@example.com or call +81 90-1234-5678 with token=supersecretvalue0000"

    let masked = engine.apply(to: text, matches: detector.detect(in: text), maskPolicy: policy)

    #expect(masked.contains("@example.com"))
    #expect(masked.contains("5678"))
    #expect(masked != text)
}

@Test
func maskingEngineMasksMultipleSensitiveValuesInOnePass() {
    let detector = RuleBasedDetector()
    let policy = DefaultMaskPolicy(style: .partial)
    let engine = MaskingEngine()
    let text = "alice@example.com / +81 90-1234-5678 / ghp_abcdefghijklmnopqrstuvwxyz123456"

    let masked = engine.apply(to: text, matches: detector.detect(in: text), maskPolicy: policy)

    #expect(masked.contains("a****@example.com"))
    #expect(masked.contains("+** **-****-5678"))
    #expect(masked.contains("ghp_"))
    #expect(masked.contains("3456"))
    #expect(masked != text)
}
