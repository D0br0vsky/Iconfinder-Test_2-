import UIKit

protocol DownloadImageUseCaseProtocol {
    func execute(
        url: String,
        shouldSaveToPhotos: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class DownloadImageUseCase: DownloadImageUseCaseProtocol {
    private let permissionManager: PermissionManagerProtocol
    private let dataLoader: DataLoaderProtocol
    
    init(permissionManager: PermissionManagerProtocol, dataLoader: DataLoaderProtocol) {
        self.permissionManager = permissionManager
        self.dataLoader = dataLoader
    }
    
    func execute(url: String, shouldSaveToPhotos: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let downloadURL = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        let request = URLRequest(url: downloadURL)
        
        dataLoader.fetchData(url: request) { [weak self] (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    
                    completion(.failure(NSError(domain: "Failed to decode image", code: -2)))
                    return
                }
                if shouldSaveToPhotos {
                    self?.permissionManager.requestPhotoLibraryPermission { granted in
                        if granted {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            completion(.success(()))
                        } else {
                            completion(.failure(NSError(domain: "Permission denied", code: -3)))
                        }
                    }
                } else {
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
