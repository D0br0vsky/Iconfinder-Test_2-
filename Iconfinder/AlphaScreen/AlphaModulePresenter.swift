
import UIKit
import Dispatch

protocol AlphaPresenterProtocol {
    func searchQueryUpdate()
    func updateQuery(_ query: String)
    func didTapDownloadButton(with url: String)
    func loadIconsData() // questionable
}

final class AlphaModulePresenter: AlphaPresenterProtocol {
    weak var view: AlphaControllerProtocol?
    
    private let dataLoader: DataLoaderProtocol
    private let dataService: DataServiceProtocol
    private let downloadImageUseCase: DownloadImageUseCaseProtocol
    
    private var loadedIconsForView: [IconsInformationModel] = []
    private var searchQuery: String = ""
    private var isLoading: Bool = false
    private var page: Int = 1

    
    init(dataLoader: DataLoaderProtocol, dataService: DataServiceProtocol, downloadImageUseCase: DownloadImageUseCaseProtocol) {
        self.dataLoader = dataLoader
        self.dataService = dataService
        self.downloadImageUseCase = downloadImageUseCase
    }
    
    func searchQueryUpdate() {
        loadedIconsForView.removeAll()
        loadIconsData()
    }
    
    func updateQuery(_ query: String) {
        searchQuery = query
    }
    
    func didTapDownloadButton(with url: String) { // finalize later
        guard !url.isEmpty else {
            return
        }
        downloadImageUseCase.execute(url: url, shouldSaveToPhotos: true) { result in
                switch result {
                case .success:
                    print("Картинка успешно скачана!")
                case .failure(let error):
                    print("Произошла ошибка: \(error.localizedDescription)")
                }
            }
        }
    
    func viewDidLoad() {
        loadIconsData()
    }
    
    func loadIconsData() {
        let dispatchGroup = DispatchGroup()
        
        guard !isLoading else { return }
        isLoading = true
        page = 1
        view?.startLoading()
        guard !searchQuery.isEmpty else {
            loadedIconsForView.removeAll()
            view?.update(model: AlphaModuleView.Model(items: []))
            view?.stopLoading()
            view?.showEmpty(text: EmptyStatusModel.emptySearchTerm)
            isLoading = false
            return
        }
        
        dispatchGroup.enter()
        dataService.fetchIcons(query: searchQuery, count: 10 * page) { [weak self] result in
            defer { dispatchGroup.leave() }
            guard let self = self else { return }
            switch result {
            case .success(let dataIcons):
                if dataIcons.icons.isEmpty {
                    loadedIconsForView.removeAll()
                    self.view?.showEmpty(text: EmptyStatusModel.nothingFound)
                    self.view?.update(model: AlphaModuleView.Model(items: []))
                } else {
                    self.convertAndAddsDataIcon(dataIcons.icons)
                    self.page += 1
                }
                self.isLoading = false
            case .failure(_):
                self.view?.showError()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.stopLoading()
            self.view?.hideAllStates()
            self.updateUI()
        }
    }
}

// MARK: - Private Helpers
private extension AlphaModulePresenter {
    func updateUI() {
        guard !loadedIconsForView.isEmpty else {
            view?.showEmpty(text: EmptyStatusModel.nothingFound)
            return
        }
        let items: [AlphaModuleViewCell.Model] = loadedIconsForView.map { iconsData in
                .init(previewURL: iconsData.previewURL, maxSize: iconsData.maxSize, tags: "\(iconsData.tags)", downloadURL: iconsData.downloadURL)
        }
        let viewModel = AlphaModuleView.Model(items: items)
        view?.update(model: viewModel)
    }
    
    func convertAndAddsDataIcon(_ dataIcons: [IconDTO]) {
        let iconArray: [Int: [IconDTO]] = groupIconsById(dataIcons)
        for (iconId, iconInfo) in iconArray {
            let (sizeMaxWidth, sizeMaxHeight) = getMaxDimensions(from: iconInfo)
            let tags = iconInfo.first?.tags ?? []
            
            let previewURL = getUrl(from: iconInfo, matchingWidth: sizeMaxWidth, matchingHeight: sizeMaxHeight, isPreview: true)
            let downloadURL = getUrl(from: iconInfo, matchingWidth: sizeMaxWidth, matchingHeight: sizeMaxHeight, isPreview: false)
            
            let iconsInformationModel = IconsInformationModel(iconID: iconId, maxSize: "\(sizeMaxWidth)px x \(sizeMaxHeight)px", tags: tags, previewURL: previewURL, downloadURL: downloadURL)
            loadedIconsForView.append(iconsInformationModel)
        }
    }
    
    func groupIconsById(_ icons: [IconDTO]) -> [Int: [IconDTO]]{
        var iconArray: [Int: [IconDTO]] = [:]
        for icon in icons {
            iconArray[icon.iconID, default:[]].append(icon)
        }
        return iconArray
    }
    
    func getMaxDimensions(from icons: [IconDTO]) -> (width: Int, height: Int) {
        let maxWidth = icons.compactMap { $0.rasterSizes?.compactMap { $0.sizeWidth }.max() }.max() ?? 0
        let maxHeight = icons.compactMap { $0.rasterSizes?.compactMap { $0.sizeHeight }.max() }.max() ?? 0
        return (maxWidth, maxHeight)
    }
    
    func getUrl(from icons: [IconDTO], matchingWidth: Int, matchingHeight: Int, isPreview: Bool) -> String {
        return icons.compactMap { icon in
            icon.rasterSizes?
                .filter { $0.sizeWidth == matchingWidth && $0.sizeHeight == matchingHeight }
                .flatMap { $0.formats.compactMap { isPreview ? $0.previewURL : $0.downloadURL } }
                .first
        }.first ?? ""
    }
}
