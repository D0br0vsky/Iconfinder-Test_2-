
import UIKit

final class ErrorViewState: UIView {
    private lazy var baseShape: UIView = {
        let shape = UIView()
        shape.backgroundColor = .red
        shape.layer.cornerRadius = 6
        return shape
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "An error occurred"
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
    
    func setMessage(_ text: String) {
            messageLabel.text = text
        }
}

// MARK: - Setup Subviews and Constraints
private extension ErrorViewState {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(baseShape)
        baseShape.addSubview(messageLabel)
    }
    
    func setupConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        baseShape.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            baseShape.topAnchor.constraint(equalTo: topAnchor),
            baseShape.trailingAnchor.constraint(equalTo: trailingAnchor),
            baseShape.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseShape.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: baseShape.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: baseShape.centerYAnchor)
        ])
    }
}
