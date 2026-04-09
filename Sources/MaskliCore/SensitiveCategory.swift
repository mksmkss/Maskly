import Foundation

public enum SensitiveCategory: String, CaseIterable, Codable, Hashable, Sendable {
    case apiKey
    case token
    case email
    case phone
    case urlSecretParam
    case personName
    case companyName

    public var displayName: String {
        switch self {
        case .apiKey: "API Key"
        case .token: "Token"
        case .email: "Email"
        case .phone: "Phone"
        case .urlSecretParam: "URL Secret"
        case .personName: "Person"
        case .companyName: "Company"
        }
    }

    public var labelToken: String {
        "[\(displayName.uppercased().replacingOccurrences(of: " ", with: "_"))]"
    }
}
