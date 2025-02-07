import UIKit

protocol AlphaViewControllerProtocol: AnyObject {
    func update(model: AlphaModuleView.Model)
    func setState(_ state: ScreenState)
    func updateCell(at indexPath: IndexPath, withColor color: UIColor)
    func startLoadingFooter()
    func stopLoadingFooter()
}

final class AlphaModuleViewController: UIViewController, UISearchBarDelegate {
    private let searchBar = UISearchBar()
    private let presenter: AlphaModulePresenter
    private let screenStateView: ScreenStateViewProtocol
    private lazy var customView = AlphaModuleView(presenter: presenter)
    
    init(presenter: AlphaModulePresenter, screenStateViewModels: ScreenStateViewProtocol) {
        self.presenter = presenter
        self.screenStateView = screenStateViewModels
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

// MARK: - AlphaViewControllerProtocol
extension AlphaModuleViewController: AlphaViewControllerProtocol {
    func setState(_ state: ScreenState) {
        stopLoadingFooter()
        screenStateView.setState(state)
    }
    
    func update(model: AlphaModuleView.Model) {
        customView.update(model: model)
    }
    
    func updateCell(at indexPath: IndexPath, withColor color: UIColor) {
        customView.updateCell(at: indexPath, withColor: color)
    }
    
    func startLoadingFooter() {
        customView.startLoadingFooter()
    }
    
    func stopLoadingFooter() {
        customView.stopLoadingFooter()
    }
}

// MARK: - Setup Subviews and Constraints
private extension AlphaModuleViewController {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(screenStateView)
    }
    
    func setupConstraints() {
        screenStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenStateView.topAnchor.constraint(equalTo: view.topAnchor),
            screenStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
