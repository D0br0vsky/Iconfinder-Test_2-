import UIKit

final class AlphaModuleFactory {
    
    struct Context {    
    }
    
    func make() -> UIViewController {
        let dataLoader = DataLoader()
        let permissionManager = PermissionManager()
        let screenStateViewModels = ScreenStateView()
        let iconDataMapper = IconDataMapper()
        let dataService = DataService(dataLoader: dataLoader)
        let iconsLoader = IconsLoader(dataService: dataService)
        let presenter = AlphaModulePresenter(dataLoader: dataLoader, dataService: dataService, permissionManager: permissionManager, iconDataMapper: iconDataMapper, iconsLoader: iconsLoader)
        let vc = AlphaModuleViewController(presenter: presenter, screenStateViewModels: screenStateViewModels)
        presenter.view = vc
        return vc
    }
}
