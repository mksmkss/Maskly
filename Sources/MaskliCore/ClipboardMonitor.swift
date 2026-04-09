import Foundation

@MainActor
public protocol ClipboardMonitor: AnyObject {
    func start()
    func stop()
}
