import AppKit
import ClipboardMaskerCore
import SwiftUI

struct MenuBarContentView: View {
    @Bindable var model: AppModel
    let openSettings: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let launchBannerMessage = model.launchBannerMessage {
                Label(launchBannerMessage, systemImage: "checkmark.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }

            Toggle("Enable masking", isOn: Binding(
                get: { model.settings.enabled },
                set: { model.setMonitoringEnabled($0) }
            ))

            VStack(alignment: .leading, spacing: 6) {
                Text(model.statusMessage)
                    .font(.headline)

                if let lastUpdatedAt = model.lastUpdatedAt {
                    Text(lastUpdatedAt.formatted(date: .abbreviated, time: .standard))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if model.lastMaskedPreview.isEmpty == false {
                Divider()
                Text("Last preview")
                    .font(.headline)
                previewBlock(title: "Original", value: model.lastOriginalPreview)
                previewBlock(title: "Masked", value: model.lastMaskedPreview)
                if model.lastDetectedCategories.isEmpty == false {
                    Text(model.lastDetectedCategories.map(\.displayName).joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()
            HStack {
                Button("Undo Last Mask") {
                    model.undoLastMask()
                }
                .disabled(model.canUndoLastMask == false)

                Spacer()

                Button(action: openSettings) {
                    Label("Settings", systemImage: "gearshape")
                }
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(14)
        .frame(width: 360)
    }

    @ViewBuilder
    private func previewBlock(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(.body, design: .monospaced))
                .lineLimit(3)
                .textSelection(.enabled)
        }
    }
}
