
import UIKit

final class AlphaView: UIView, UISearchBarDelegate, UICollectionViewDelegate {
    
    // Используем typealias, что бы было красиво :)
    typealias item = CellView.Model
    
    // Модель через которую передают все изменения во View/TableView
    struct Model {
        let items: [item]
    }
    
    private var data: [CellView.Model] = []
    
    private func loadDataFromAPI() {
        presenter.viewDidLoad() // Запускаем загрузку данных через presenter
    }
    
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
        return searchBar
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "find"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 14
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside) // Добавлено действие
        return button
    }()
    
    private lazy var collectionView:  UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(CellView.self, forCellWithReuseIdentifier: CellView.id)
        return collectionView
    }()
    
    //    private lazy var contentView: UIView = { // это у нас что мы поместим в скролл
    //        let contentView = UIView()
    //        contentView.backgroundColor = .gray
    //        // contentView.frame.size = contentSize
    //        return contentView
    //    }()
    
    //    private lazy var stackView: UIStackView = { // тут будет контент наши карточки
    //        let stackView = UIStackView()
    //        stackView.axis = .vertical
    //        stackView.alignment = .fill
    //        stackView.spacing = 20
    //        return stackView
    //    }()
    
    
    // тут был
    
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
    
    
    //    func configure(with value: [Icon]) {
    //        /// Удаляем старые карточки перед добавлением новых
    //        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    //
    //        /// Добавляем header элементы/
    //        stackView.addArrangedSubview(searchBar)
    //        stackView.addArrangedSubview(searchButton)
    //
    //        /// Добавляем карточки
    //        for cell in value {
    //            let cellView = CellView()
    //            let model = CellView.Model(
    //                maxSize: "\(cell.rasterSizes.first?.sizeWidth ?? 0)x\(cell.rasterSizes.first?.sizeHeight ?? 0)",
    //                tags: cell.tags.joined(separator: ", "),
    //                buttonText: "Download"
    //            )
    //
    //            cellView.update(model: model)
    //            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    //            stackView.addArrangedSubview(cellView)
    //
    //            /// Устанавливаем высоту для cellView
    //            cellView.translatesAutoresizingMaskIntoConstraints = false
    //            cellView.heightAnchor.constraint(equalToConstant: 540).isActive = true
    //        }
    //    }
    
    func configure(presenter: AlphaPresenterProtocol) { // Убедитесь, что этот метод добавлен
        self.presenter = presenter
    }
    
    func update(model: Model) {
        self.data = model.items
        collectionView.reloadData()
        
        /*
         stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
         model.items.forEach { item in
         let cellView = CellView()
         cellView.update(model: item)
         cellView.onDownloadButtonTap = { [weak self] in
         self?.presenter.downloadImage(for: 0, from: item.buttonText) // Здесь вы можете изменить index.
         }
         stackView.addArrangedSubview(cellView)
         cellView.translatesAutoresizingMaskIntoConstraints = false
         cellView.heightAnchor.constraint(equalToConstant: 540).isActive = true
         }
         */
    }
    
    // нажатие кнопки "Поиск" на клавиатуре
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        presenter.searchButtonTapped(with: searchText)
        searchBar.resignFirstResponder()
    }
    
    func showError() {
        // Показываем View ошибки
    }
    
    func showEmpty() {
        // Показываем какой-то View для Empty state
    }
    
    func startLoader() {
        // Показываем скелетон или лоадер
    }
    
    func stopLoader() {
        // Скрываем все
    }
    
}


private extension AlphaView {
    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
        //loadDataFromAPI()
    }
    
    func setupSubviews() {
        
        addSubview(topShape)
        addSubview(collectionView)
        topShape.addSubview(searchBar)
        topShape.addSubview(searchButton)
        searchBar.delegate = self // Устанавливаем делегата
    }
    
    private func setupConstraints() {
        topShape.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // TopShape
            topShape.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            topShape.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            topShape.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            topShape.heightAnchor.constraint(equalToConstant: 50),
            
            // SearchBar
            searchBar.topAnchor.constraint(equalTo: topShape.topAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: topShape.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            // SearchButton
            searchButton.topAnchor.constraint(equalTo: topShape.topAnchor, constant: 5),
            searchButton.trailingAnchor.constraint(equalTo: topShape.trailingAnchor, constant: -5),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            // TableView
            collectionView.topAnchor.constraint(equalTo: topShape.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    @objc private func searchButtonTapped() {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        presenter.searchButtonTapped(with: searchText) // Передаем запрос в Presenter
        searchBar.resignFirstResponder()
    }
}

// MARK: - Extensions AlphaView
extension AlphaView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.id, for: indexPath) as? CellView else {
            fatalError("Failed to dequeue CellView")
        }
        cell.reset() // Новый метод для сброса состояния
        let item = data[indexPath.row]
        cell.configure(with: item) { [weak self] in
            self?.presenter.downloadImage(for: item.iconID, from: item.buttonText)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 10, height: 520) // Ширина почти равна ширине коллекции, высота - 200.
    }
}

