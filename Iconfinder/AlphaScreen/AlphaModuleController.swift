
import UIKit

protocol AlphaControllerProtocol: AnyObject {
    func update(model: AlphaModuleView.Model)
    func showError()
    func showEmpty()
    func startLoader()
    func stopLoader()
}

final class AlphaModuleController: UIViewController {
    private let presenter: AlphaModulePresenter
    private lazy var customView = AlphaModuleView(presenter: presenter)
    
    init(presenter: AlphaModulePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        presenter.viewDidLoad()
    }
}

extension AlphaModuleController: AlphaControllerProtocol {
    func update(model: AlphaModuleView.Model) {
        customView.update(model: model)
    }
    
    func showEmpty() {
        customView.showEmpty()
    }
    
    func startLoader() {
        customView.startLoader()
    }
    
    func stopLoader() {
        customView.stopLoader()
    }
    
    func showError() {
        customView.showError()
    }
}

