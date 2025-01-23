import UIKit
import Kingfisher

final class AlphaModuleViewCell: UICollectionViewCell {
    static let id = "AlphaModuleViewCell"
    
    private var model: Model?
    struct Model {
        let previewURL: String
        let maxSize: String
        let tags: String
        let downloadURL: String
        
    }

    private lazy var imageCard: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 14
        image.clipsToBounds = true
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
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
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
    
    func update(model: Model) {
        self.model = model
        if let url = URL(string: model.previewURL) {
            imageCard.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.2))])
        }
        sizeLabel.text = model.maxSize
        tagsLabel.text = model.tags
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
        sizeLabel.text = nil
        tagsLabel.text = nil
        imageCard.image = nil
    }
}

// MARK: - Setup Subviews and Constraints
private extension AlphaModuleViewCell {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
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
        sizeImage.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsImage.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func downloadButtonTapped() {
        guard let model = model else {
            return
        }
        
        guard !model.downloadURL.isEmpty else {
            return
        }

        DispatchQueue.main.async {
            self.downloadButton.setImage(UIImage(named: "ok"), for: .normal)
        }
        presenter?.didTapDownloadButton(with: model.downloadURL)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.downloadButton.setImage(UIImage(named: "download"), for: .normal)
        }
    }

}
