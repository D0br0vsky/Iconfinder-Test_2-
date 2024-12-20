
import UIKit

extension UIImageView {
    func loadImageURL(from urlString: String, palceHolder: UIImage? = nil) {
        self.image = palceHolder
        
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
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
}
