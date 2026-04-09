import MaskliCore
import SwiftUI

struct SettingsView: View {
    @Bindable var model: AppModel

    var body: some View {
        Form {
            Section("General") {
                Toggle("Enable masking", isOn: Binding(
                    get: { model.settings.enabled },
                    set: { model.setMonitoringEnabled($0) }
                ))

                Toggle("Launch at login", isOn: Binding(
                    get: { model.settings.launchAtLogin },
                    set: { model.setLaunchAtLogin($0) }
                ))

                if let launchAtLoginMessage = model.launchAtLoginMessage {
                    Text(launchAtLoginMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Categories") {
                ForEach([
                    SensitiveCategory.apiKey,
                    .token,
                    .email,
                    .phone,
                    .urlSecretParam,
                ], id: \.self) { category in
                    Toggle(category.displayName, isOn: Binding(
                        get: { model.settings.enabledCategories.contains(category) },
                        set: { model.toggleCategory(category, isEnabled: $0) }
                    ))
                }
            }

            Section("Mask Style") {
                Picker("Display", selection: Binding(
                    get: { model.settings.maskStyle },
                    set: { model.setMaskStyle($0) }
                )) {
                    ForEach(MaskStyle.allCases, id: \.self) { style in
                        Text(style.displayName).tag(style)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Last Conversion") {
                LabeledContent("Original") {
                    Text(model.lastOriginalPreview.isEmpty ? "-" : model.lastOriginalPreview)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Masked") {
                    Text(model.lastMaskedPreview.isEmpty ? "-" : model.lastMaskedPreview)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Detections") {
                    Text("\(model.detectionCount)")
                }

                Button("Undo Last Mask") {
                    model.undoLastMask()
                }
                .disabled(model.canUndoLastMask == false)
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 560)
    }
}
