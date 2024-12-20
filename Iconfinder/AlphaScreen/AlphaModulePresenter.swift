
import Foundation

protocol AlphaPresenterProtocol {
    
}

final class AlphaModulePresenter: AlphaPresenterProtocol {
    private var dataLoader: DataLoader
    private let dataService: DataServiceProtocol
    private var iconsInformation: [IconsInformationModel] = []
    
    weak var view: AlphaControllerProtocol?
    
    init(dataLoader: DataLoader, dataService: DataService) {
        self.dataLoader = dataLoader
        self.dataService = dataService
    }
    
    func viewDidLoad() {
        iconsInformationLoader()
    }
    
    func iconsInformationLoader() {
        view?.startLoader()
        
        dataService.fetchIcons(query: "star", count: 10) { [weak self] result in
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
        
    }
}
