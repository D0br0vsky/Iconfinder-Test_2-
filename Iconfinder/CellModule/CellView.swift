
import UIKit

protocol CellViewProtocol: AnyObject {
    func showError(_ message: String)
    func showSuccess(_ message: String)
}

final class CellView: UICollectionViewCell {
    
    private var onDownloadButtonTap: (() -> Void)?
    
    static let id = "CellView"
    
    // Модель через которую передают все изменения во View из Presenter
    struct Model {
        let iconID: Int
        let maxSize: String // Текст для отображения
        let tags: String // Текст для отображения
        let buttonText: String // Текст на кнопке
        let imageURL: String // URL изображения
    }
    
    
    private lazy var imageCard: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "test") // тестовое изображение
        image.layer.cornerRadius = 14
        image.clipsToBounds = true // Обязательно для работы закругления
        return image
    }()
    
    private lazy var tagsImage = UIImageView()
    private lazy var sizeImage = UIImageView()
    
    private lazy var baseShape: UIView = {
        let shape = UIView()
        shape.backgroundColor = .lightGray
        shape.layer.cornerRadius = 14
        return shape
    }()
    
    private lazy var sizeShape: UIView = {
        let shape = UIView()
        shape.backgroundColor = .white
        shape.layer.cornerRadius = 8
        return shape
    }()
    
    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var tagsShape: UIView = {
        let shape = UIView()
        shape.backgroundColor = .white
        shape.layer.cornerRadius = 8
        return shape
    }()
    
    private lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "download"), for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var presenter: AlphaPresenterProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        tagsImage.image = UIImage(named: "tags")
        sizeImage.image = UIImage(named: "size")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Конфигурация
    
    public func configure(with model: Model, downloadAction: @escaping () -> Void) {
        sizeLabel.text = model.maxSize
        tagsLabel.text = model.tags
        onDownloadButtonTap = downloadAction

        if let url = URL(string: model.imageURL) {
            downloadImage(from: url)
        } else {
            imageCard.image = UIImage(named: "placeholder")
        }
    }
    
    /// Наверно нужно перетащить это в Presenter
    private func downloadImage(from url: URL) {
            // Вы можете использовать стороннюю библиотеку для кэширования изображений, например, SDWebImage
            // Здесь для простоты используем URLSession
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageCard.image = image
                    }
                } else {
                    // Обработка ошибки
                    DispatchQueue.main.async {
                        self.imageCard.image = UIImage(named: "placeholder")
                    }
                }
            }.resume()
        }
    
    // Метод для обновления View на основе модели
    func update(model: Model) {
        sizeLabel.text = model.maxSize
        tagsLabel.text = model.tags
        downloadButton.setTitle(model.buttonText, for: .normal) // Обновляем текст кнопки
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onDownloadButtonTap = nil
        sizeLabel.text = nil
        tagsLabel.text = nil
        imageCard.image = nil
    }
}

private extension CellView {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        //stackView.addArrangedSubview(baseShape) /// чет мутное обратить внимание при ошибках <-------
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        contentView.addSubview(baseShape)
        baseShape.addSubview(imageCard)
        baseShape.addSubview(sizeShape)
        baseShape.addSubview(tagsShape)
        baseShape.addSubview(downloadButton)
        sizeShape.addSubview(sizeImage)
        sizeShape.addSubview(sizeLabel)
        tagsShape.addSubview(tagsImage)
        tagsShape.addSubview(tagsLabel)
    }
    
    func setupConstraints() {
        
        baseShape.translatesAutoresizingMaskIntoConstraints = false
        imageCard.translatesAutoresizingMaskIntoConstraints = false
        sizeShape.translatesAutoresizingMaskIntoConstraints = false
        tagsShape.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        sizeImage.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsImage.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            baseShape.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            baseShape.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            baseShape.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            baseShape.heightAnchor.constraint(equalToConstant: 520),
            
            imageCard.topAnchor.constraint(equalTo: baseShape.topAnchor, constant: 10),
            imageCard.trailingAnchor.constraint(equalTo: baseShape.trailingAnchor, constant: -5),
            imageCard.leadingAnchor.constraint(equalTo: baseShape.leadingAnchor, constant: 5),
            imageCard.heightAnchor.constraint(equalToConstant: 350),
            
            sizeShape.topAnchor.constraint(equalTo: imageCard.bottomAnchor, constant: 10),
            sizeShape.trailingAnchor.constraint(equalTo: baseShape.trailingAnchor, constant: -10),
            sizeShape.leadingAnchor.constraint(equalTo: baseShape.leadingAnchor, constant: 10),
            sizeShape.heightAnchor.constraint(equalToConstant: 40),
            
            sizeImage.topAnchor.constraint(equalTo: sizeShape.topAnchor, constant: 5),
            sizeImage.leadingAnchor.constraint(equalTo: sizeShape.leadingAnchor, constant: 5),
            sizeImage.widthAnchor.constraint(equalToConstant: 30),
            sizeImage.heightAnchor.constraint(equalToConstant: 30),
            
            sizeLabel.topAnchor.constraint(equalTo: sizeShape.topAnchor, constant: 5),
            sizeLabel.leadingAnchor.constraint(equalTo: sizeImage.trailingAnchor, constant: 10),
            sizeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            tagsShape.topAnchor.constraint(equalTo: sizeShape.bottomAnchor, constant: 10),
            tagsShape.trailingAnchor.constraint(equalTo: baseShape.trailingAnchor, constant: -10),
            tagsShape.leadingAnchor.constraint(equalTo: baseShape.leadingAnchor, constant: 10),
            tagsShape.heightAnchor.constraint(equalToConstant: 40),
            
            tagsImage.topAnchor.constraint(equalTo: tagsShape.topAnchor, constant: 5),
            tagsImage.leadingAnchor.constraint(equalTo: tagsShape.leadingAnchor, constant: 5),
            tagsImage.widthAnchor.constraint(equalToConstant: 30),
            tagsImage.heightAnchor.constraint(equalToConstant: 30),
            
            tagsLabel.topAnchor.constraint(equalTo: tagsShape.topAnchor, constant: 5),
            tagsLabel.leadingAnchor.constraint(equalTo: tagsImage.trailingAnchor, constant: 10),
            tagsLabel.trailingAnchor.constraint(equalTo: tagsShape.trailingAnchor, constant: -5),
            tagsLabel.heightAnchor.constraint(equalToConstant: 30),
            
            downloadButton.topAnchor.constraint(equalTo: tagsShape.bottomAnchor, constant: 10),
            downloadButton.trailingAnchor.constraint(equalTo: baseShape.trailingAnchor, constant: -10),
            downloadButton.leadingAnchor.constraint(equalTo: baseShape.leadingAnchor, constant: 10),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    @objc func downloadButtonTapped() {
        onDownloadButtonTap?()
    }
}

extension CellView: CellViewProtocol {
    func showError(_ message: String) {
        print("Error: \(message)")
    }
    
    func showSuccess(_ message: String) {
        print("Success: \(message)")
    }
}

extension CellView {
    func reset() {
        sizeLabel.text = nil
        tagsLabel.text = nil
        onDownloadButtonTap = nil
    }
}
