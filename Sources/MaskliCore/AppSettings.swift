import Foundation

public struct AppSettings: Codable, Equatable, Sendable {
    public var enabled: Bool
    public var launchAtLogin: Bool
    public var enabledCategories: Set<SensitiveCategory>
    public var maskStyle: MaskStyle

    public init(
        enabled: Bool = true,
        launchAtLogin: Bool = false,
        enabledCategories: Set<SensitiveCategory> = Set([
            .apiKey, .token, .email, .phone, .urlSecretParam,
        ]),
        maskStyle: MaskStyle = .partial
    ) {
        self.enabled = enabled
        self.launchAtLogin = launchAtLogin
        self.enabledCategories = enabledCategories
        self.maskStyle = maskStyle
    }

    public static let `default` = AppSettings()
}
