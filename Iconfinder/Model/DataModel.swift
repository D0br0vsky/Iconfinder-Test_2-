
struct SearchResult: Codable {
    let icons: [Icon]
}

// основная модель для работы с JSON

struct Icon: Codable {
    let iconID: Int?
    let name: String?
    let tags: [String]?
    let rasterSizes: [RasterSize]?

    enum CodingKeys: String, CodingKey {
        case iconID = "icon_id"
        case name
        case tags
        case rasterSizes = "raster_sizes"
    }
}

struct RasterSize: Codable {
    let sizeWidth: Int?
    let sizeHeight: Int?
    let formats: [Format]?

    enum CodingKeys: String, CodingKey {
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
        case formats
    }
}

struct Format: Codable {
    let format: String?
    let downloadURL: String?
    let previewURL: String?

    enum CodingKeys: String, CodingKey {
        case format
        case downloadURL = "download_url"
        case previewURL = "preview_url"
    }
}


/// Пример ответа в формате JSON
/*
{
  "total_count": 242,
  "icons": [
    {
      "icon_id": 380453,
      "name": "Nirion: Merry Christmas 3D",
      "is_premium": true,
      "raster_sizes": [
        {
          "size_width": 512,
          "size_height": 512,
          "formats": [
            {
              "format": "png",
              "download_url": "https://cdn.iconfinder.com/data/icons/nirion-merry-christmas-3d/512/icon.png"
            }
          ]
        }
      ],
      "tags": ["christmas", "holiday", "3d"]
    },
    {
      "icon_id": 380454,
      "name": "Nirion: New Year 3D",
      "is_premium": false,
      "raster_sizes": [
        {
          "size_width": 256,
          "size_height": 256,
          "formats": [
            {
              "format": "png",
              "download_url": "https://cdn.iconfinder.com/data/icons/nirion-new-year-3d/256/icon.png"
            }
          ]
        }
      ],
      "tags": ["new year", "holiday", "3d"]
    }
  ]
}

*/
