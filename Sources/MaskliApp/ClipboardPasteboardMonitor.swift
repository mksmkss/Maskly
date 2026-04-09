import AppKit
import MaskliCore
import Foundation

@MainActor
final class ClipboardPasteboardMonitor: ClipboardMonitor {
    private let pasteboard: NSPasteboard
    private let pollInterval: TimeInterval
    private var timer: Timer?
    private var lastChangeCount: Int
    private let onStringCopied: (String) -> Void

    init(
        pasteboard: NSPasteboard = .general,
        pollInterval: TimeInterval = 0.6,
        onStringCopied: @escaping (String) -> Void
    ) {
        self.pasteboard = pasteboard
        self.pollInterval = pollInterval
        self.lastChangeCount = pasteboard.changeCount
        self.onStringCopied = onStringCopied
    }

    func start() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.poll()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func replaceClipboardText(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }

    private func poll() {
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount

        guard let value = pasteboard.string(forType: .string) else { return }
        onStringCopied(value)
    }
}
