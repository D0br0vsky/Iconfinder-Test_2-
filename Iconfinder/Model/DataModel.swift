
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
    let publishedAt: String
    let isPremium: Bool
    let type: String
    let containers: [Container]
    let rasterSizes: [RasterSize]?
    let styles: [Style]?
    let categories: [Category]?
    let isIconGlyph: Bool
    
    enum CodingKeys: String, CodingKey {
        case iconID = "icon_id"
        case tags
        case publishedAt = "published_at"
        case isPremium = "is_premium"
        case type
        case containers
        case rasterSizes = "raster_sizes"
        case styles
        case categories
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
    let size: Int
    let sizeWidth: Int
    let sizeHeight: Int
    
    enum CodingKeys: String, CodingKey {
        case formats
        case size
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
    }
}

struct Format: Codable {
    let format: String
    let previewURL: String?
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case format
        case previewURL = "preview_url"
        case downloadURL = "download_url"
    }
}

struct Style: Codable {
    let identifier: String
    let name: String
}

struct Category: Codable {
    let identifier: String
    let name: String
}
