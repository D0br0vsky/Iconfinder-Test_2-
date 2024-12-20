
import UIKit

final class AlphaModuleView: UIView, UISearchBarDelegate, UICollectionViewDelegate {
    typealias item = AlphaModuleViewCell.Model
    struct Model {
        let items: [item]
    }
    private var data: [AlphaModuleViewCell.Model] = []
    private var model: Model?
    
    private lazy var topShape: UIView = {
        let shape = UIView()
        shape.backgroundColor = .black
        shape.layer.cornerRadius = 14
        return shape
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Start your search ..."
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "find"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 14
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView:  UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 380, height: 20)
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
        self.model = model
        self.data = model.items
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func showError() {
        
    }
    
    func showEmpty() {
        
    }
    
    func startLoader() {
        
    }
    
    func stopLoader() {
        
    }
}

// MARK: - UICollectionViewDataSource
extension AlphaModuleView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlphaModuleViewCell.id, for: indexPath) as? AlphaModuleViewCell else {
            return UICollectionViewCell()
        }
        let item = data[indexPath.item]
        cell.update(model: item)
        return cell
    }
}

// MARK: - ConstraintsSubviews
private extension AlphaModuleView {
    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        
        addSubview(topShape)
        addSubview(collectionView)
        topShape.addSubview(searchBar)
        topShape.addSubview(searchButton)
    }
    
    private func setupConstraints() {
        topShape.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            topShape.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            topShape.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            topShape.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            topShape.heightAnchor.constraint(equalToConstant: 50),
            
            searchBar.topAnchor.constraint(equalTo: topShape.topAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: topShape.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.topAnchor.constraint(equalTo: topShape.topAnchor, constant: 5),
            searchButton.trailingAnchor.constraint(equalTo: topShape.trailingAnchor, constant: -5),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: topShape.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func searchButtonTapped() {
        
    }
}

