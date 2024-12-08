
import UIKit

final class AlphaFactory {
    
    struct Context {
        
    }
    
    func make() -> UIViewController {
        let service = RestService()
        
        let presenter = AlphaPresenter(serviсe: service)
        
        let vc = AlphaController(presenter: presenter)
        
        presenter.view = vc
        
        return vc
    }
}
