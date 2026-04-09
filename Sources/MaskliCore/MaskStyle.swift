import Foundation

public enum MaskStyle: String, CaseIterable, Codable, Sendable {
    case partial
    case full
    case categoryLabel

    public var displayName: String {
        switch self {
        case .partial: "Partial"
        case .full: "Full"
        case .categoryLabel: "Category Label"
        }
    }
}
