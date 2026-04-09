import MaskliCore
import Foundation

@MainActor
final class AppSettingsStore {
    private enum Keys {
        static let appSettings = "clipboardMasker.appSettings"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> AppSettings {
        guard let data = defaults.data(forKey: Keys.appSettings),
              let settings = try? JSONDecoder().decode(AppSettings.self, from: data)
        else {
            return .default
        }
        return settings
    }

    func save(_ settings: AppSettings) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: Keys.appSettings)
    }
}
