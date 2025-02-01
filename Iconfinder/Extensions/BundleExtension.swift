import Foundation

extension Bundle {
    var apiKey: String {
        return object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
}
