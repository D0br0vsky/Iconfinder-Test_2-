
import UIKit

protocol AlphaControllerProtocol: AnyObject {
    func update(model: AlphaModuleView.Model)
    func showError()
    func showEmpty(text: String)
    func startLoading()
    func stopLoading()
    func hideAllStates()
}

final class AlphaModuleController: UIViewController, UISearchBarDelegate {
    private let searchBar = UISearchBar()
    private let presenter: AlphaModulePresenter
    private lazy var customView = AlphaModuleView(presenter: presenter)
    private let screenStateViewModels: ScreenStateViewModelsProtocol
    
    init(presenter: AlphaModulePresenter, screenStateViewModels: ScreenStateViewModelsProtocol) {
        self.presenter = presenter
        self.screenStateViewModels = screenStateViewModels
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let screenStateViewModels = screenStateViewModels as? UIView {
                view.addSubview(screenStateViewModels)
                screenStateViewModels.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    screenStateViewModels.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
                    screenStateViewModels.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    screenStateViewModels.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    screenStateViewModels.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            }

            presenter.viewDidLoad()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let query = searchBar.text, !query.isEmpty else { return }
            presenter.updateQuery(query)
            presenter.searchQueryUpdate()
            searchBar.resignFirstResponder()
        }
}

// MARK: - AlphaControllerProtocol
extension AlphaModuleController: AlphaControllerProtocol {
    func update(model: AlphaModuleView.Model) {
        customView.update(model: model)
    }
    func showError() {
        screenStateViewModels.showError()
    }
    
    func showEmpty(text: String) {
        screenStateViewModels.showEmpty(text: text)
    }
    
    func startLoading() {
        screenStateViewModels.startLoading()
    }
    
    func stopLoading() {
        screenStateViewModels.stopLoading()
    }
    
    func hideAllStates() {
        screenStateViewModels.hideAllStates()
    }
}
