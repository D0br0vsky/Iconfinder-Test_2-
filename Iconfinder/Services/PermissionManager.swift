import Photos

protocol PermissionManagerProtocol {
    func requestPhotoLibraryPermission(complition: @escaping (Bool) -> Void)
}

final class PermissionManager: PermissionManagerProtocol {
    func requestPhotoLibraryPermission(complition: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            complition(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    complition(newStatus == .authorized)
                }
            }
        default:
            complition(false)
        }
    }
}
