
import UIKit

final class AlertModuleFactory {
    func make(title: String, message: String) -> UIViewController {
        let alertViewController = UIAlertController(
            title: title, // Заголовок алерта
            message: message, // Сообщение алерта
            preferredStyle: .alert // Стиль алерта (в данном случае стандартный)
        )
        let action = UIAlertAction(
            title: "Ok", // Текст кнопки действия
            style: .default, // Стиль действия
            handler: nil // Обработчик нажатия (nil означает отсутствие действия)
        )
        alertViewController.addAction(action)
        return alertViewController
    }
}
