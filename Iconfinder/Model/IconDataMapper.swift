import Foundation

protocol IconDataMapperProtocol {
    func map(_ dataIcons: [Icon]) -> [IconsInformationModel]
}

final class IconDataMapper: IconDataMapperProtocol {
    func map(_ dataIcons: [Icon]) -> [IconsInformationModel] {
        let groupedIcons = groupIconsById(dataIcons)
        return groupedIcons.compactMap { iconId, iconInfo in
            createIconsInformationModel(iconId: iconId, iconInfo: iconInfo)
        }
    }
    
    private func groupIconsById(_ icons: [Icon]) -> [Int: [Icon]] {
        var iconArray: [Int: [Icon]] = [:]
        for icon in icons {
            iconArray[icon.iconID, default: []].append(icon)
        }
        return iconArray
    }
    
    private func createIconsInformationModel(iconId: Int, iconInfo: [Icon]) -> IconsInformationModel? {
        let (sizeMaxWidth, sizeMaxHeight) = getMaxDimensions(from: iconInfo)
        guard let tags = iconInfo.first?.tags else { return nil }
        
        let previewURL = getUrl(from: iconInfo, matchingWidth: sizeMaxWidth, matchingHeight: sizeMaxHeight, isPreview: true)
        let downloadURL = getUrl(from: iconInfo, matchingWidth: sizeMaxWidth, matchingHeight: sizeMaxHeight, isPreview: false)
        
        return IconsInformationModel(
            iconID: iconId,
            maxSize: "\(sizeMaxWidth) x \(sizeMaxHeight)",
            tags: tags,
            previewURL: previewURL,
            downloadURL: downloadURL
        )
    }
    
    private func getMaxDimensions(from icons: [Icon]) -> (width: Int, height: Int) {
        let maxWidth = icons.compactMap { $0.rasterSizes?.compactMap { $0.sizeWidth }.max() }.max() ?? 0
        let maxHeight = icons.compactMap { $0.rasterSizes?.compactMap { $0.sizeHeight }.max() }.max() ?? 0
        return (maxWidth, maxHeight)
    }
    
    private func getUrl(from icons: [Icon], matchingWidth: Int, matchingHeight: Int, isPreview: Bool) -> String {
        return icons.compactMap { icon in
            icon.rasterSizes?
                .filter { $0.sizeWidth == matchingWidth && $0.sizeHeight == matchingHeight }
                .flatMap { $0.formats.compactMap { isPreview ? $0.previewURL : $0.downloadURL } }
                .first
        }.first ?? ""
    }
    
}
