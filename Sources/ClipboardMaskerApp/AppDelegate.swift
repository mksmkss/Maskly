import AppKit
import Foundation

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    let model = AppModel()

    private var statusBarController: StatusBarController?
    private var settingsWindowController: SettingsWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        settingsWindowController = SettingsWindowController(model: model)
        statusBarController = StatusBarController(
            model: model,
            openSettings: { [weak self] in
                self?.settingsWindowController?.show()
            }
        )
    }
}
