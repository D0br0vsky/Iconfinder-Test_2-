
struct IconsInformationModel {
    let iconID: Int
    let maxSize: String
    let tags: [String]
    let previewURL: String
    let downloadURL: String
}

struct TextStatusModel {
    static let emptySearchTerm = "🟢 Enter your search term."
    static let nothingFound = "🟠 Nothing found, try again."
    static let connectionError = "🔴 Error: No connection to server."
    static let accessError = "🟣 No access to album."
    static let successfulDownload = "✅✅✅✅✅"
    static let downloadError = "❌❌❌❌❌"
}
