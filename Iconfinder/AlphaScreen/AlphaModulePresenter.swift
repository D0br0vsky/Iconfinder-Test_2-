
import Foundation

protocol AlphaPresenterProtocol {
    
}

final class AlphaModulePresenter: AlphaPresenterProtocol {
    private var dataLoader = DataLoader()
    private let dataService: DataServiceProtocol
    
    weak var view: AlphaControllerProtocol?
    var testArray: [IconDTO] = []
    
    init(dataLoader: DataLoader, dataService: DataService) {
        self.dataLoader = dataLoader
        self.dataService = dataService
    }
    
    func viewDidLoad() {
        dataService.fetchIcons(query: "star", count: 10) { result in
            switch result {
            case .success(let icons):
                print("Fetched \(icons.totalCount) icons")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func someDataLoad() {
        
    }
    
}
