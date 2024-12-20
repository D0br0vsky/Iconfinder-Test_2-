
import UIKit

final class AlphaModuleFactory {
    
    struct Context {    
    }
    
    func make() -> UIViewController {
        let dataLoader = DataLoader()
        let dataService = DataService(dataLoader: dataLoader)
        let presenter = AlphaModulePresenter(dataLoader: dataLoader, dataService: dataService)
        let vc = AlphaModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
