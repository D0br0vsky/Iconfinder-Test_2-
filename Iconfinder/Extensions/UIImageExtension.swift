
import UIKit
import Photos

extension UIImageView {
    func loadImageURL(from urlString: String, palceHolder: UIImage? = nil) {
        self.image = palceHolder
        
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, responce, error in
            if error != nil {
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.sync {
                self.image = image
            }
        }
        .resume()
    }
    
    func checkForDownload(from urlString: String, shouldSaveToPhotos: Bool = false) {
            guard let url = URL(string: urlString) else {
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                    if shouldSaveToPhotos {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                }
            }.resume()
        }
}
