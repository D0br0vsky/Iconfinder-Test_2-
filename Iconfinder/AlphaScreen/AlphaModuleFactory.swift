
import UIKit

final class AlphaModuleFactory {
    
    struct Context {    
    }
    
    func make() -> UIViewController {
        let service = DataLoader()
        let presenter = AlphaModulePresenter(service: service)
        let vc = AlphaModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
