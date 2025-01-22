
import UIKit

final class AlphaModuleFactory {
    
    struct Context {    
    }
    
    func make() -> UIViewController {
        let dataLoader = DataLoader()
        let permissionManager = PermissionManager()
        let screenStateViewModels = ScreenStateViewModels()
        let dataService = DataService(dataLoader: dataLoader)
        let presenter = AlphaModulePresenter(dataLoader: dataLoader, dataService: dataService, permissionManager: permissionManager)
        let vc = AlphaModuleController(presenter: presenter, screenStateViewModels: screenStateViewModels)
        presenter.view = vc
        return vc
    }
}
