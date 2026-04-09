import AppKit
import SwiftUI

@MainActor
final class SettingsWindowController: NSWindowController {
    init(model: AppModel) {
        let hostingController = NSHostingController(rootView: SettingsView(model: model))
        let window = NSWindow(contentViewController: hostingController)

        window.title = "Settings"
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.setContentSize(NSSize(width: 560, height: 460))
        window.center()
        window.isReleasedWhenClosed = false

        super.init(window: window)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        guard let window else { return }
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
