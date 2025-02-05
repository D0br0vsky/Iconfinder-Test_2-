import UIKit
import Photos
import Dispatch

protocol AlphaPresenterProtocol {
    func searchUpdate(_ query: String)
    func prefetchData(for indexPaths: [IndexPath])
    func loadsWhenTapped(indexPath: IndexPath)
}

final class AlphaModulePresenter: AlphaPresenterProtocol {
    weak var view: AlphaViewControllerProtocol?
    internal var isLoading: Bool = false
    
    private let dataLoader: DataLoaderProtocol
    private let dataService: DataServiceProtocol
    private let permissionManager: PermissionManagerProtocol
    private let iconDataMapper: IconDataMapperProtocol
    private let iconsLoader: IconsLoaderProtocol
    private let debouncer = CancellableExecutor(queue: .main)
    
    private var loadedIconsForView: [IconsInformationModel] = []
    private var searchQuery: String = ""
    private var page: Int = 1
    
    init(dataLoader: DataLoaderProtocol, dataService: DataServiceProtocol, permissionManager: PermissionManagerProtocol, iconDataMapper: IconDataMapperProtocol, iconsLoader: IconsLoaderProtocol) {
        self.dataLoader = dataLoader
        self.dataService = dataService
        self.iconsLoader = iconsLoader
        self.iconDataMapper = iconDataMapper
        self.permissionManager = permissionManager
    }
    
    func searchUpdate(_ query: String) {
        searchQuery = query
        debouncer.execute(delay: .milliseconds(400)) { [weak self] isCancelled in
            guard let self = self, !isCancelled.isCancelled else { return }
            searchQueryUpdate()
        }
    }

    func prefetchData(for indexPaths: [IndexPath]) {
        let shouldLoadMore = indexPaths.contains { $0.row >= (loadedIconsForView.count - 5) }
        if shouldLoadMore && !isLoading {
            loadIconsData(isPagination: true)
        }
    }
    
    func loadsWhenTapped(indexPath: IndexPath) {
        let downloadURL = loadedIconsForView[indexPath.row].downloadURL
        
        guard indexPath.row < loadedIconsForView.count else {
            view?.showError()
            return
        }
        
        permissionManager.requestPhotoLibraryPermission { [weak self] permission in
            guard permission else {
                self?.view?.showError()
                self?.view?.updateCell(at: indexPath, withColor: .systemRed)
                return
            }
            
            self?.dataService.downloadImage(from: downloadURL) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        self?.view?.updateCell(at: indexPath, withColor: .systemRed)
                        return
                    }
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    self?.view?.updateCell(at: indexPath, withColor: .systemGreen)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.view?.hideEmpty()
                    }
                case .failure(_):
                    self?.view?.showError()
                    self?.view?.updateCell(at: indexPath, withColor: .systemRed)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.view?.hideAllStates()
                    }
                }
            }
        }
    }
    
    func searchQueryUpdate() {
        loadedIconsForView.removeAll()
        page = 1
        loadIconsData()
    }
    
    func viewDidLoad() {
        loadIconsData()
    }
    
    func loadIconsData(isPagination: Bool = false) {
        guard !isLoading, !searchQuery.isEmpty else {
            handleEmptyQuery()
            return
        }
        isLoading = true
        view?.hideAllStates()
        
        if isPagination {
            view?.startLoadingFooter()
        } else {
            view?.startLoading()
        }
        
        iconsLoader.loadIcons(query: searchQuery, page: page) { [weak self] result in
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
        self.view?.hideAllStates()
        self.updateUI()
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
                tags: iconsData.tags.joined(separator: " | "),
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
        view?.showEmpty()
        isLoading = false
    }
    
    func handleLoadedIcons(_ dataIcons: [Icon]) {
        let iconsData = iconDataMapper.map(dataIcons)
        
        if iconsData.isEmpty {
            view?.hideAllStates()
            loadedIconsForView.removeAll()
            view?.update(model: AlphaModuleView.Model(items: []))
            view?.showNotFound()
        } else {
            let uniqueIcons = iconsData.filter { newIcon in
                !loadedIconsForView.contains(where: { $0.iconID == newIcon.iconID })
            }
            
            loadedIconsForView.append(contentsOf: uniqueIcons)
            page += 1
            updateUI()
        }
    }
}
