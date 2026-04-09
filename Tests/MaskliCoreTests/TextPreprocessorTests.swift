@testable import MaskliCore
import Testing

@Test
func preprocessConvertsFullwidthAsciiWithoutTouchingKatakana() {
    let preprocessor = TextPreprocessor()
    let text = "ＡＰＩキーはｓｂ＿ＡＢＣ１２３とカタカナアイウです"

    let processed = preprocessor.preprocess(text)

    #expect(processed == "APIキーはsb_ABC123とカタカナアイウです")
}

@Test
func preprocessKeepsFullwidthKatakanaUnchanged() {
    let preprocessor = TextPreprocessor()
    let text = "マスクリ アイウエオ"

    let processed = preprocessor.preprocess(text)

    #expect(processed == text)
}
