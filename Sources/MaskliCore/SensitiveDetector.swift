import Foundation

public protocol SensitiveDetector {
    func detect(in text: String) -> [SensitiveMatch]
}
