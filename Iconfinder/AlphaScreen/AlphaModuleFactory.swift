import UIKit

final class AlphaModuleFactory {
    func make() -> UIViewController {
        let dataLoader = DataLoader()
        let permissionManager = PermissionManager()
        let screenStateView = ScreenStateView()
        let iconDataMapper = IconDataMapper()
        let dataDecoder = DataDecoder()
        let dataService = DataService(dataLoader: dataLoader, dataDecoder: dataDecoder)
        let iconsLoader = IconsLoader(dataService: dataService)
        let presenter = AlphaModulePresenter(dataLoader: dataLoader, dataService: dataService, permissionManager: permissionManager, iconDataMapper: iconDataMapper, iconsLoader: iconsLoader)
        let vc = AlphaModuleViewController(presenter: presenter, screenStateViewModels: screenStateView)
        presenter.view = vc
        return vc
    }
}
