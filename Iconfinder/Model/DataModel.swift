struct IconsResponse: Codable {
    let totalCount: Int
    let icons: [IconDTO]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case icons
    }
}

struct IconDTO: Codable {
    let iconID: Int
    let tags: [String]
    let isPremium: Bool
    let containers: [Container]
    let rasterSizes: [RasterSize]?
    let isIconGlyph: Bool
    
    enum CodingKeys: String, CodingKey {
        case iconID = "icon_id"
        case tags
        case isPremium = "is_premium"
        case containers
        case rasterSizes = "raster_sizes"
        case isIconGlyph = "is_icon_glyph"
    }
}

struct Container: Codable {
    let format: String
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case format
        case downloadURL = "download_url"
    }
}

struct RasterSize: Codable {
    let formats: [Format]
    let sizeWidth: Int
    let sizeHeight: Int
    
    enum CodingKeys: String, CodingKey {
        case formats
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
    }
}

struct Format: Codable {
    let previewURL: String?
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case previewURL = "preview_url"
        case downloadURL = "download_url"
    }
}
