
import UIKit

protocol AlphaControllerProtocol: AnyObject {
    func startLoader()
    func stopLoader()
    func update(model: AlphaView.Model)
    func showError(_ message: String)
    func showSuccess(_ message: String)
    func showEmpty()
}

final class AlphaController: UIViewController {
    
    private lazy var customView = AlphaView(presenter: presenter)
    var presenter: AlphaPresenterProtocol
    
    init(presenter: AlphaPresenterProtocol) {
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
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    /// ДЛЯ ОШИБКИ ИСПРАВЛЕНИЯ ????
    /// где и сколько распознавателей жестов создается
    func countGestureRecognizers(in view: UIView) -> Int {
        var count = view.gestureRecognizers?.count ?? 0
        for subview in view.subviews {
            count += countGestureRecognizers(in: subview)
        }
        return count
    }
    
}

extension AlphaController: AlphaControllerProtocol {
    
    func update(model: AlphaView.Model) {
        customView.update(model: model)
    }
    
    func showError() {
        customView.showEmpty()
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
    
    func showError(_ message: String) {
        print("Error: \(message)")
    }
    
    func showSuccess(_ message: String) {
        print("Success: \(message)")
    }
}

