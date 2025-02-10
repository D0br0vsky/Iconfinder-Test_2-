import UIKit
import Photos
import Dispatch

protocol AlphaPresenterProtocol: AnyObject {
    func searchUpdate(_ query: String)
    func prefetchData(for indexPaths: [IndexPath])
    func loadsWhenTapped(indexPath: IndexPath)
}

final class AlphaModulePresenter: AlphaPresenterProtocol {
    weak var view: AlphaViewControllerProtocol?
    
    private let dataLoader: DataLoaderProtocol
    private let dataService: DataServiceProtocol
    private let permissionManager: PermissionManagerProtocol
    private let iconDataMapper: IconDataMapperProtocol
    private let iconsLoader: IconsLoaderProtocol
    private let debouncer = CancellableExecutor(queue: .main)
    
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
        guard indexPath.row < loadedIconsForView.count else {
            view?.setState(.error)
            return
        }
        
        let downloadURL = loadedIconsForView[indexPath.row].downloadURL
        
        permissionManager.requestPhotoLibraryPermission { [weak self] permission in
            guard permission else {
                self?.view?.setState(.error)
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
                        self?.view?.setState(.content)
                    }
                case .failure(_):
                    self?.view?.setState(.error)
                    self?.view?.updateCell(at: indexPath, withColor: .systemRed)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.view?.setState(.empty)
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
        
        if isPagination {
            view?.startLoadingFooter()
        } else {
            view?.setState(.loading)
        }
        
        iconsLoader.loadIcons(query: searchQuery, page: page) { [weak self] result in
            guard let self = self else { return }
            isLoading = false
            view?.setState(.content)
            
            switch result {
            case .success(let dataIcons):
                handleLoadedIcons(dataIcons.icons)
                isLoading = false
            case .failure(_):
                view?.setState(.error)
            }
        }
    }
}

// MARK: - Private Methods
private extension AlphaModulePresenter {
    func updateUI() {
        guard !loadedIconsForView.isEmpty else {
            return
        }
        
        let items = loadedIconsForView.map {
            AlphaModuleViewCell.Model(
                previewURL: $0.previewURL,
                maxSize: $0.maxSize,
                tags: $0.tags.joined(separator: " | "),
                downloadURL: $0.downloadURL
            )
        }

        let viewModel = AlphaModuleView.Model(items: items)
        view?.update(model: viewModel)
    }
    
    func handleEmptyQuery() {
        loadedIconsForView.removeAll()
        view?.update(model: AlphaModuleView.Model(items: []))
        view?.setState(.empty)
        
        isLoading = false
    }
    
    func handleLoadedIcons(_ dataIcons: [Icon]) {
        let iconsData = iconDataMapper.map(dataIcons)
        
        if iconsData.isEmpty {
            loadedIconsForView.removeAll()
            view?.update(model: AlphaModuleView.Model(items: []))
            view?.setState(.notFound)
        } else {
            loadedIconsForView.append(contentsOf: iconsData)
            page += 1
            updateUI()
        }
    }
}
