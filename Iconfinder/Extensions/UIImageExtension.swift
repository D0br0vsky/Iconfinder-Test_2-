
import UIKit
import Photos

extension UIImageView {
    func loadImageURL(from url: String, completion: @escaping () -> Void) {
        self.image = nil
        
        guard let url = URL(string: url) else {
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self?.image = image
                } else {
                    self?.image = UIImage(named: "errorImage")
                }
                completion()
            }
        }.resume()
    }
}
