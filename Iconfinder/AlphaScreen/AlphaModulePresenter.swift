import UIKit
import Photos
import Dispatch

protocol AlphaPresenterProtocol {
    func updateQuery(_ query: String)
    func didTapDownloadButton(with url: String)
    func searchQueryUpdate()
    func loadIconsData()
}

final class AlphaModulePresenter: AlphaPresenterProtocol {
    weak var view: AlphaControllerProtocol?
    
    private let dataLoader: DataLoaderProtocol
    private let dataService: DataServiceProtocol
    private let permissionManager: PermissionManagerProtocol
    private let iconDataMapper: IconDataMapperProtocol
    private let iconsLoader: IconsLoaderProtocol
    
    private var loadedIconsForView: [IconsInformationModel] = []
    private var searchQuery: String = ""
    private var isLoading: Bool = false
    private var page: Int = 1
    
    init(dataLoader: DataLoaderProtocol, dataService: DataServiceProtocol, permissionManager: PermissionManagerProtocol, iconDataMapper: IconDataMapperProtocol, iconsLoader: IconsLoaderProtocol) {
        self.dataLoader = dataLoader
        self.dataService = dataService
        self.iconsLoader = iconsLoader
        self.iconDataMapper = iconDataMapper
        self.permissionManager = permissionManager
    }
    
    func searchQueryUpdate() {
        loadedIconsForView.removeAll()
        loadIconsData()
    }
    
    func updateQuery(_ query: String) {
        searchQuery = query
    }
    
    func didTapDownloadButton(with url: String) {
        permissionManager.requestPhotoLibraryPermission { [weak self] permission in
            guard permission else {
                self?.view?.showError()
                return
            }
            
            self?.dataService.downloadImage(from: url) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    
                    DispatchQueue.main.async {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        self?.view?.showEmpty()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self?.view?.hideEmpty()
                        }
                    }
                case .failure(_):
                    self?.view?.showError()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.view?.hideAllStates()
                    }
                }
            }
        }
    }
    
    func viewDidLoad() {
        loadIconsData()
    }
    
    func loadIconsData() {
        let dispatchGroup = DispatchGroup()
        guard !isLoading, !searchQuery.isEmpty else {
            handleEmptyQuery()
            return
        }
        isLoading = true
        view?.hideAllStates()
        view?.startLoading()
        
        dispatchGroup.enter()
        iconsLoader.loadIcons(query: searchQuery, page: page) { [weak self] result in
            defer { dispatchGroup.leave() }
            guard let self = self else { return }
            self.isLoading = false
            self.view?.stopLoading()
            
            switch result {
            case .success(let dataIcons):
                handleLoadedIcons(dataIcons.icons)
                self.isLoading = false
            case .failure(_):
                self.view?.showError()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.stopLoading()
            self.updateUI()
        }
    }
}

// MARK: - Private Methods
private extension AlphaModulePresenter {
    func updateUI() {
        guard !loadedIconsForView.isEmpty else {
            return
        }

        let items: [AlphaModuleViewCell.Model] = loadedIconsForView.map { iconsData in
            return AlphaModuleViewCell.Model(
                previewURL: iconsData.previewURL,
                maxSize: iconsData.maxSize,
                tags: "\(iconsData.tags)",
                downloadURL: iconsData.downloadURL
            )
        }

        let viewModel = AlphaModuleView.Model(items: items)
        view?.update(model: viewModel)
    }
    
    func handleEmptyQuery() {
        view?.hideAllStates()
        loadedIconsForView.removeAll()
        view?.update(model: AlphaModuleView.Model(items: []))
        view?.stopLoading()
        view?.showEmpty()
        isLoading = false
    }
    
    func handleLoadedIcons(_ dataIcons: [Icon]) {
        let iconsData = iconDataMapper.map(dataIcons)

        if iconsData.isEmpty {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view?.stopLoading()
                self.loadedIconsForView.removeAll()
                self.view?.update(model: AlphaModuleView.Model(items: []))
                self.view?.showNotFound()
            }
        } else {
            loadedIconsForView.append(contentsOf: iconsData)
            page += 1
            updateUI()
        }
    }

}
