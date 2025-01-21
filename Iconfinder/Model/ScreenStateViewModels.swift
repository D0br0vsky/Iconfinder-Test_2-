
import UIKit

protocol ScreenStateViewModelsProtocol: UIView {
    func showError()
    func showEmpty(text: String)
    func startLoading()
    func stopLoading()
    func hideAllStates()
}

final class ScreenStateViewModels: UIView {
    private lazy var errorView: ErrorViewState = {
        let view = ErrorViewState()
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingView: LoadingViewState = {
        let view = LoadingViewState()
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyView: EmptyViewState = {
        let view = EmptyViewState()
        view.isHidden = true
        return view
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

// MARK: - ScreenStateViewModelsProtocol
extension ScreenStateViewModels: ScreenStateViewModelsProtocol {
    func showError() {
        DispatchQueue.main.async { [weak self] in
            self?.hideAllStates()
            self?.errorView.isHidden = false
            self?.isUserInteractionEnabled = false
            self?.bringSubviewToFront(self?.errorView ?? UIView())
        }
    }
    
    func showEmpty(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.emptyView.isHidden = false
            self?.emptyView.setMessage(text)
            self?.isUserInteractionEnabled = false
            self?.bringSubviewToFront(self?.emptyView ?? UIView())
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.isHidden = false
            self?.isUserInteractionEnabled = false
            self?.bringSubviewToFront(self?.loadingView ?? UIView())
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.isHidden = true
            self?.isUserInteractionEnabled = false
            self?.bringSubviewToFront(self?.loadingView ?? UIView())
        }
    }
    
    func hideAllStates() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.isHidden = true
            self?.errorView.isHidden = true
            self?.emptyView.isHidden = true
            self?.isUserInteractionEnabled = false
        }
    }
    
   
}

// MARK: - Setup Subviews and Constraints
private extension ScreenStateViewModels {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(errorView)
        addSubview(loadingView)
        addSubview(emptyView)
    }
    
    func setupConstraints() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: topAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyView.topAnchor.constraint(equalTo: topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
