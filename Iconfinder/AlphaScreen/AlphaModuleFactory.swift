
import UIKit

final class AlphaModuleFactory {
    
    struct Context {    
    }
    
    func make() -> UIViewController {
        let dataLoader = DataLoader()
        let cacheManager = CacheManager()
        let permissionManager = PermissionManager()
        let screenStateViewModels = ScreenStateViewModels()
        let downloadImageUseCase = DownloadImageUseCase(permissionManager: permissionManager, dataLoader: dataLoader)
        let dataService = DataService(dataLoader: dataLoader, cacheManager: cacheManager)
        let presenter = AlphaModulePresenter(dataLoader: dataLoader, dataService: dataService, downloadImageUseCase: downloadImageUseCase)
        let vc = AlphaModuleController(presenter: presenter, screenStateViewModels: screenStateViewModels)
        presenter.view = vc
        return vc
    }
}
