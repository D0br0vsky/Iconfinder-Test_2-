
import UIKit

final class LoadingViewState: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading ..."
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Subviews and Constraints
private extension LoadingViewState {
    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(activityIndicator)
        addSubview(messageLabel)
        activityIndicator.startAnimating()
    }
    
    func setupConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
