import AppKit
import MaskliCore
import Foundation
import Observation

@MainActor
@Observable
final class AppModel {
    var settings: AppSettings {
        didSet {
            settingsStore.save(settings)
            syncLaunchAtLogin()
        }
    }

    var lastOriginalPreview = ""
    var lastMaskedPreview = ""
    var lastDetectedCategories: [SensitiveCategory] = []
    var detectionCount = 0
    var lastUpdatedAt: Date?
    var statusMessage = "Watching clipboard"
    var launchAtLoginMessage: String?
    var launchBannerMessage: String?
    var canUndoLastMask: Bool { lastOriginalText != nil }

    private let settingsStore: AppSettingsStore
    private let detector: any SensitiveDetector
    private let contextualDetector: any SensitiveDetector
    private let preprocessor = TextPreprocessor()
    private let maskingEngine = MaskingEngine()
    private let launchManager = LaunchAtLoginManager()
    private var monitor: ClipboardPasteboardMonitor?
    private var lastOriginalText: String?

    init(
        settingsStore: AppSettingsStore = AppSettingsStore(),
        detector: any SensitiveDetector = RuleBasedDetector(),
        contextualDetector: any SensitiveDetector = ContextualDetector()
    ) {
        self.settingsStore = settingsStore
        self.settings = settingsStore.load()
        self.detector = detector
        self.contextualDetector = contextualDetector
        configureMonitor()
        syncLaunchAtLogin(refreshOnly: true)
        if settings.enabled {
            monitor?.start()
        } else {
            statusMessage = "Clipboard monitoring paused"
        }

        showLaunchBanner()
    }

    func setMonitoringEnabled(_ isEnabled: Bool) {
        settings.enabled = isEnabled
        if isEnabled {
            monitor?.start()
            statusMessage = "Watching clipboard"
        } else {
            monitor?.stop()
            statusMessage = "Clipboard monitoring paused"
        }
    }

    func toggleCategory(_ category: SensitiveCategory, isEnabled: Bool) {
        if isEnabled {
            settings.enabledCategories.insert(category)
        } else {
            settings.enabledCategories.remove(category)
        }
    }

    func setMaskStyle(_ style: MaskStyle) {
        settings.maskStyle = style
    }

    func setLaunchAtLogin(_ enabled: Bool) {
        settings.launchAtLogin = enabled
    }

    func undoLastMask() {
        guard let original = lastOriginalText else {
            statusMessage = "Nothing to undo"
            return
        }

        monitor?.replaceClipboardText(original)
        statusMessage = "Restored last clipboard value"
        lastOriginalText = nil
    }

    private func configureMonitor() {
        monitor = ClipboardPasteboardMonitor { [weak self] copiedText in
            self?.handleClipboardString(copiedText)
        }
    }

    private func handleClipboardString(_ copiedText: String) {
        guard settings.enabled else { return }

        let prepared = preprocessor.preprocess(copiedText)
        let primaryMatches = detector.detect(in: prepared)
        let futureMatches = contextualDetector.detect(in: prepared)
        let enabledMatches = (primaryMatches + futureMatches).filter {
            settings.enabledCategories.contains($0.category)
        }

        guard enabledMatches.isEmpty == false else {
            statusMessage = "No sensitive content detected"
            return
        }

        let maskPolicy = DefaultMaskPolicy(style: settings.maskStyle)
        let masked = maskingEngine.apply(to: prepared, matches: enabledMatches, maskPolicy: maskPolicy)

        guard masked != prepared else {
            statusMessage = "Detected values did not require changes"
            return
        }

        monitor?.replaceClipboardText(masked)

        lastOriginalText = copiedText
        lastOriginalPreview = preview(of: copiedText)
        lastMaskedPreview = preview(of: masked)
        lastDetectedCategories = Array(Set(enabledMatches.map(\.category))).sorted { $0.rawValue < $1.rawValue }
        detectionCount = enabledMatches.count
        lastUpdatedAt = .now
        statusMessage = "Masked \(enabledMatches.count) sensitive value(s)"
    }

    private func preview(of text: String) -> String {
        let trimmed = text.replacingOccurrences(of: "\n", with: " ")
        return String(trimmed.prefix(140))
    }

    private func syncLaunchAtLogin(refreshOnly: Bool = false) {
        if refreshOnly {
            settings.launchAtLogin = launchManager.currentStatus() == .enabled
            return
        }

        do {
            try launchManager.setEnabled(settings.launchAtLogin)
            launchAtLoginMessage = nil
        } catch {
            launchAtLoginMessage = error.localizedDescription
        }
    }

    func showLaunchBanner() {
        launchBannerMessage = "\(AppMetadata.appName) is running in the menu bar"
    }

    func dismissLaunchBanner() {
        launchBannerMessage = nil
    }
}
