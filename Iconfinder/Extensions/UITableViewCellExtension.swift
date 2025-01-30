import UIKit

extension UITableViewCell {
    func flashBackgroundColor(_ color: UIColor, duration: TimeInterval = 0.3, revertAfter: TimeInterval = 1.5) {
        let originalColor = contentView.backgroundColor ?? .systemBackground
        UIView.animate(withDuration: duration, animations: {
            self.contentView.backgroundColor = color
        }) { _ in
            UIView.animate(withDuration: duration, delay: revertAfter, options: [], animations: {
                self.contentView.backgroundColor = originalColor
            })
        }
    }
}
