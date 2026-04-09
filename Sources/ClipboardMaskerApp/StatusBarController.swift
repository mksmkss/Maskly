import AppKit
import SwiftUI

@MainActor
final class StatusBarController: NSObject {
    private let openSettingsAction: () -> Void
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let popover = NSPopover()
    private let model: AppModel
    private var autoCloseTask: DispatchWorkItem?
    private var launchPopoverAttempts = 0

    init(model: AppModel, openSettings: @escaping () -> Void) {
        self.model = model
        self.openSettingsAction = openSettings
        super.init()

        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(
            rootView: MenuBarContentView(model: model) { [weak self] in
                self?.openSettings()
            }
        )

        configureStatusItem()
        showLaunchPopover()
    }

    func openSettings() {
        popover.performClose(nil)
        model.dismissLaunchBanner()
        openSettingsAction()
    }

    private func configureStatusItem() {
        guard let button = statusItem.button else { return }

        button.image = NSImage(
            systemSymbolName: "lock.shield.fill",
            accessibilityDescription: "ClipboardMasker"
        )
        button.imagePosition = .imageOnly
        button.toolTip = "ClipboardMasker"
        button.target = self
        button.action = #selector(togglePopover(_:))
    }

    private func showLaunchPopover() {
        DispatchQueue.main.async { [weak self] in
            self?.presentLaunchPopoverWhenReady()
        }
    }

    private func presentPopover(autoClose: Bool) {
        guard let button = statusItem.button else { return }

        autoCloseTask?.cancel()

        if popover.isShown == false {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }

        guard autoClose else { return }

        let task = DispatchWorkItem { [weak self] in
            self?.model.dismissLaunchBanner()
            self?.popover.performClose(nil)
        }
        autoCloseTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: task)
    }

    private func presentLaunchPopoverWhenReady() {
        guard let button = statusItem.button else { return }

        if isStatusItemReady(button) {
            presentPopover(autoClose: true)
            return
        }

        guard launchPopoverAttempts < 20 else { return }
        launchPopoverAttempts += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.presentLaunchPopoverWhenReady()
        }
    }

    private func isStatusItemReady(_ button: NSStatusBarButton) -> Bool {
        guard let window = button.window,
              let screen = window.screen
        else {
            return false
        }

        guard button.bounds.isEmpty == false else {
            return false
        }

        let screenRect = window.convertToScreen(button.convert(button.bounds, to: nil))
        guard screenRect.isEmpty == false else {
            return false
        }

        return screenRect.maxY >= screen.visibleFrame.maxY - 12
    }

    @objc
    private func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            autoCloseTask?.cancel()
            model.dismissLaunchBanner()
            popover.performClose(sender)
        } else {
            presentPopover(autoClose: false)
        }
    }
}
