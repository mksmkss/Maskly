import Foundation

enum AppMetadata {
    static let appName = "Maskli"
    static let creatorName = "mksmkss"

    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    static var menuFooter: String {
        "v\(version) | created by \(creatorName)"
    }
}
