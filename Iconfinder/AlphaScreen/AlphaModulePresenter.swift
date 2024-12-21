
import Foundation

protocol AlphaPresenterProtocol {
    func searchQueryUpdated()
    func updateQuery(_ query: String)
}

final class AlphaModulePresenter: AlphaPresenterProtocol {
    private var dataLoader: DataLoader
    private let dataService: DataServiceProtocol
    private var iconsInformation: [IconsInformationModel] = []
    private var currentQuery: String = "emoji"
    
    weak var view: AlphaControllerProtocol?
    
    init(dataLoader: DataLoader, dataService: DataService) {
        self.dataLoader = dataLoader
        self.dataService = dataService
    }
    
    func searchQueryUpdated() {
        iconsInformation.removeAll()
        iconsInformationLoader()
    }
    
    func updateQuery(_ query: String) {
        currentQuery = query
    }
    
    func viewDidLoad() {
        iconsInformationLoader()
    }
    
    func iconsInformationLoader() {
        view?.startLoader()
        dataService.fetchIcons(query: currentQuery, count: 22) { [weak self] result in
            guard let self = self else { return }
            self.view?.stopLoader()
            switch result {
            case .success(let dataIcons):
                convertAndAddsDataIcon(dataIcons.icons)
                updateUI()
                print(dataIcons.totalCount)
            case .failure(_):
                self.view?.showError()
            }
        }
    }
}

// MARK: - Extension private
extension AlphaModulePresenter {
    func updateUI() {
        guard !iconsInformation.isEmpty else {
            view?.showEmpty()
            return
        }
        let items: [AlphaModuleViewCell.Model] = iconsInformation.map { iconsData in
                .init(previewURL: iconsData.previewURL, maxSize: iconsData.maxSize, tags: "\(iconsData.tags)", downloadURL: iconsData.downloadURL)
        }
        let viewModel = AlphaModuleView.Model(items: items)
        view?.update(model: viewModel)
    }
    
    func convertAndAddsDataIcon(_ dataIcons: [IconDTO]) {
        var iconArray: [Int: [IconDTO]] = [:]
        for iconId in dataIcons {
            iconArray[iconId.iconID, default: []].append(iconId)
        }
        
        for (iconId, iconInfo) in iconArray {
            
            let sizeMaxWidth = iconInfo
                .compactMap { $0.rasterSizes?.compactMap { $0.sizeWidth }.max() }
                .max() ?? 0
            
            let sizeMaxHeight = iconInfo
                .compactMap { $0.rasterSizes?.compactMap { $0.sizeHeight }.max() }
                .max() ?? 0
  
            let tags = iconInfo.first?.tags ?? []

            let previewURL = iconInfo
                .compactMap { icon in icon.rasterSizes?
                        .filter { $0.sizeHeight == sizeMaxHeight && $0.sizeWidth == sizeMaxWidth }
                        .flatMap { $0.formats.compactMap { $0.previewURL } }.first }
                        .first ?? ""
            
    
            let downloadURL = iconInfo
                .compactMap { icon in icon.rasterSizes?
                        .filter { $0.sizeHeight == sizeMaxHeight && $0.sizeWidth == sizeMaxWidth }
                        .flatMap { $0.formats.map { $0.downloadURL } }
                        .first }.first ?? ""
            
            let value = IconsInformationModel(iconID: iconId, maxSize: "\(sizeMaxWidth)px x \(sizeMaxHeight)px", tags: tags, previewURL: previewURL, downloadURL: downloadURL)
            iconsInformation.append(value)
        }
    }
}
