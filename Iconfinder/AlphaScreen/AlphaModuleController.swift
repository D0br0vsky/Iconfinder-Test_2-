import UIKit

protocol AlphaControllerProtocol: AnyObject {
    func update(model: AlphaModuleView.Model)
    func showError()
    func hideError()
    func showEmpty()
    func hideEmpty()
    func showNotFound()
    func hideNotFound()
    func startLoading()
    func stopLoading()
    func hideAllStates()
    func updateCell(at indexPath: IndexPath, withColor color: UIColor)
}

final class AlphaModuleController: UIViewController, UISearchBarDelegate {
    private let searchBar = UISearchBar()
    private let presenter: AlphaModulePresenter
    private lazy var customView = AlphaModuleView(presenter: presenter)
    private let screenStateViewModels: ScreenStateViewProtocol
    
    init(presenter: AlphaModulePresenter, screenStateViewModels: ScreenStateViewProtocol) {
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
        commonInit()
        presenter.viewDidLoad()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
}

// MARK: - AlphaControllerProtocol
extension AlphaModuleController: AlphaControllerProtocol {
    func update(model: AlphaModuleView.Model) {
        customView.update(model: model)
    }
    
    func showError() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.showError()
        }
    }
    
    func hideError() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.hideError()
        }
    }
    
    func showEmpty() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.showEmpty()
        }
    }
    
    func hideEmpty() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.hideEmpty()
        }
    }
    
    func showNotFound() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.showNotFound()
        }
    }
    
    func hideNotFound() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.hideNotFound()
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.startLoading()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.stopLoading()
        }
    }
    
    func hideAllStates() {
        DispatchQueue.main.async { [self] in
            screenStateViewModels.hideAllStates()
        }
    }
    
    func updateCell(at indexPath: IndexPath, withColor color: UIColor) {
        DispatchQueue.main.async {
            self.customView.updateCell(at: indexPath, withColor: color)
        }
    }
}

// MARK: - Setup Subviews and Constraints
private extension AlphaModuleController {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(screenStateViewModels)
    }
    
    func setupConstraints() {
        screenStateViewModels.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenStateViewModels.topAnchor.constraint(equalTo: view.topAnchor),
            screenStateViewModels.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenStateViewModels.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenStateViewModels.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
