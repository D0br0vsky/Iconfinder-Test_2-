
struct IconsInformationModel {
    let iconID: Int
    let maxSize: String
    let tags: [String]
    let previewURL: String
    let downloadURL: String
}

struct EmptyStatusModel {
    static let emptySearchTerm = "🟢 Enter your search term."
    static let nothingFound = "🔴 Nothing found, try again."
}
