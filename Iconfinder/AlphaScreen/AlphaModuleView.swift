import UIKit

final class AlphaModuleView: UIView {
    typealias item = AlphaModuleViewCell.Model
    struct Model {
        let items: [item]
    }
    
    private var data: [AlphaModuleViewCell.Model] = []
    private var model: Model?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Start your search ..."
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.layer.shadowOpacity = 0
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .white
        return searchBar
    }()
    
    private lazy var tableView: UITableView  = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(AlphaModuleViewCell.self, forCellReuseIdentifier: AlphaModuleViewCell.id)
        return tableView
    }()
    
    private lazy var loadingFooterView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .medium)
        loading.hidesWhenStopped = true
        return loading
    }()
    
    var presenter: AlphaPresenterProtocol
    
    init(presenter: AlphaPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(at indexPath: IndexPath, withColor color: UIColor) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? AlphaModuleViewCell {
            cell.flashBackgroundColor(color)
        }
    }

    func startLoadingFooter() {
        loadingFooterView.startAnimating()
        tableView.tableFooterView = loadingFooterView
    }
    
    func stopLoadingFooter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.loadingFooterView.stopAnimating()
            self?.tableView.tableFooterView = nil
        }
    }
    
    func update(model: Model) {
        self.model = model
        data = model.items
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension AlphaModuleView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchUpdate(searchText)
    }
}

// MARK: - UIScrollViewDelegate
extension AlphaModuleView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        presenter.prefetchData(for: indexPaths)
    }
}

// MARK: - UITableViewDataSource
extension AlphaModuleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlphaModuleViewCell.id, for: indexPath) as? AlphaModuleViewCell else {
            fatalError("Failed to create AlphaModuleViewCell")
        }
        
        guard let item = model?.items[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.update(model: item)
        cell.presenter = presenter
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AlphaModuleView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard (model?.items[indexPath.row]) != nil else { return }
        presenter.loadsWhenTapped(indexPath: indexPath)
    }
}

// MARK: - Setup Subviews and Constraints
private extension AlphaModuleView {
    func commonInit() {
        backgroundColor = .white
        tableView.tableFooterView = loadingFooterView
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
