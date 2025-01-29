import UIKit

final class AlphaModuleView: UIView, UICollectionViewDelegate {
    typealias item = AlphaModuleViewCell.Model
    struct Model {
        let items: [item]
    }
    
    private let debouncer = CancellableExecutor(queue: .main)
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
    
    private lazy var collectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 380, height: 520)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(AlphaModuleViewCell.self, forCellWithReuseIdentifier: AlphaModuleViewCell.id)
        return collectionView
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
    
    func update(model: Model) {
        DispatchQueue.main.async { [weak self] in
            self?.model = model
            self?.data = model.items
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension AlphaModuleView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.execute(delay: .milliseconds(300)) { [weak self] isCancelled in
            guard !isCancelled.isCancelled else { return }
            self?.presenter.updateQuery(searchText)
            self?.presenter.searchQueryUpdate()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        presenter.updateQuery(searchBar.text ?? "")
    }
}

// MARK: - UIScrollViewDelegate
extension AlphaModuleView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
       
        if offsetY > contentHeight - height * 2 {
            presenter.loadIconsData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AlphaModuleView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlphaModuleViewCell.id, for: indexPath) as? AlphaModuleViewCell else {
            fatalError("Failed to create AlphaModuleViewCell")
        }
        
        guard let item = model?.items[indexPath.item] else {
            return UICollectionViewCell()
        }

        cell.update(model: item)
        cell.presenter = presenter
        return cell
    }
}

// MARK: - Setup Subviews and Constraints
private extension AlphaModuleView {
    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(searchBar)
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
