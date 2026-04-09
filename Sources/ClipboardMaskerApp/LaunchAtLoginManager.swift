import Foundation
import ServiceManagement

@MainActor
final class LaunchAtLoginManager {
    func setEnabled(_ isEnabled: Bool) throws {
        if isEnabled {
            try SMAppService.mainApp.register()
        } else {
            try SMAppService.mainApp.unregister()
        }
    }

    func currentStatus() -> SMAppService.Status {
        SMAppService.mainApp.status
    }
}
