
struct SearchResult: Codable {
    let icons: [IconDTO]
}

struct IconDTO: Codable {
    let iconID: Int?
    let name: String?
    let tags: [String]?
    let rasterSizes: [RasterSizeDTO]?

    enum CodingKeys: String, CodingKey {
        case iconID = "icon_id"
        case name
        case tags
        case rasterSizes = "raster_sizes"
    }
}

struct RasterSizeDTO: Codable {
    let sizeWidth: Int?
    let sizeHeight: Int?
    let formats: [FormatDTO]?

    enum CodingKeys: String, CodingKey {
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
        case formats
    }
}

struct FormatDTO: Codable {
    let format: String?
    let downloadURL: String?
    let previewURL: String?

    enum CodingKeys: String, CodingKey {
        case format
        case downloadURL = "download_url"
        case previewURL = "preview_url"
    }
}
