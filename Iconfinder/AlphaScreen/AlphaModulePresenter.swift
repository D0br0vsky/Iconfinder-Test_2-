
import Foundation

protocol AlphaPresenterProtocol {
    
}

final class AlphaModulePresenter: AlphaPresenterProtocol {
    private let service: DataLoader
    weak var view: AlphaControllerProtocol?
    
    var testArray: [IconDTO] = []
    
    init(service: DataLoader) {
        self.service = service
    }
    
    func viewDidLoad() {
        service.fetchData { value in
            value.icons.count
        }
    }
    
    func someDataLoad() {
        
    }
    
}
