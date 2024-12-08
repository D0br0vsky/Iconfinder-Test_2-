
import Foundation

protocol AlphaPresenterProtocol {
    var view: AlphaControllerProtocol? { get set }
    func viewDidLoad()
    func downloadImage(for iconID: Int, from url: String) // Метод, вызываемый при нажатии на кнопку
    func searchButtonTapped(with searchText: String)
}

final class AlphaPresenter: AlphaPresenterProtocol {
    
    weak var view: AlphaControllerProtocol?
    
    private let serviсe: RestServiceProtocol
    private var model: [Icon]?
    
    init(serviсe: RestServiceProtocol) {
        self.serviсe = serviсe
    }
    
    
    // MARK: - Методы AlphaPresenterProtocol
    
    func viewDidLoad() {
        view?.startLoader()
        
        let count = 10
        let premium = false
        let vector = false
        let query = "apple"
        
        serviсe.loadIcons(count: count, premium: premium, vector: vector, query: query) { [weak self] (result: Result<[Icon], NetworkError>) in
            guard let self else { return }
            self.view?.stopLoader()
            
            switch result {
            case .success(let model):
                self.model = model
                self.updateUI() // Метод, который обновляет UI
            case .failure(let error):
                self.view?.showError("Ошибка загрузки: \(error.localizedDescription)")
            }
        }
    }
    
    
    /// Реализация загрузки картинки
    func downloadImage(for iconID: Int, from url: String) {
        guard let downloadURL = URL(string: url) else {
            view?.showError("Неверный URL")
            return
        }
        
        view?.startLoader()
        URLSession.shared.dataTask(with: downloadURL) { [weak self] data, response, error in
            guard let self else { return }
            self.view?.stopLoader()
            
            if let error = error {
                self.view?.showError("Ошибка загрузки: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                self.view?.showError("Нет данных для загрузки")
                return
            }
            do {
                try self.saveImage(data: data, for: iconID)
                self.view?.showSuccess("Изображение сохранено")
            } catch {
                self.view?.showError("Ошибка сохранения: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func searchButtonTapped(with searchText: String) {
        view?.startLoader()
        
        let count = 20
        let premium = false
        let vector = false
        
        serviсe.loadIcons(count: count, premium: premium, vector: vector, query: searchText) { [weak self] result in
            guard let self = self else { return }
            self.view?.stopLoader()
            
            switch result {
            case .success(let model):
                self.model = model
                self.updateUI() // Обновляем UI с полученными данными
            case .failure(let error):
                let errorMessage: String
                switch error {
                case .invalidURL:
                    errorMessage = "Неверный URL запроса."
                case .invalidResponse:
                    errorMessage = "Неверный ответ от сервера."
                case .noData:
                    errorMessage = "Данные отсутствуют."
                case .decodingError(let decodingError):
                    errorMessage = "Ошибка декодирования данных: \(decodingError.localizedDescription)"
                case .unknown(let unknownError):
                    errorMessage = "Неизвестная ошибка: \(unknownError?.localizedDescription ?? "нет описания")."
                case .custom(let message):
                    errorMessage = message
                }
                self.view?.showError("Ошибка загрузки: \(errorMessage)")
            }
        }
    }
    
    // MARK: - Приватные методы
    private func saveImage(data: Data, for iconID: Int) throws {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirectory.appendingPathComponent("icon_\(iconID).png")
        
        try data.write(to: fileURL)
        print("файл сохранен: \(fileURL.path)")
    }
    
    private func updateUI() {
        guard let model = model, !model.isEmpty else {
            view?.showEmpty()
            return
        }

        let items: [CellView.Model] = model.compactMap { icon in
            guard
                let iconID = icon.iconID,
                let rasterSizes = icon.rasterSizes,
                let firstRasterSize = rasterSizes.first,
                let formats = firstRasterSize.formats,
                let firstFormat = formats.first,
                let downloadURL = firstFormat.downloadURL ?? firstFormat.previewURL
            else {
                return nil
            }

            let sizeWidth = firstRasterSize.sizeWidth ?? 0
            let sizeHeight = firstRasterSize.sizeHeight ?? 0
            let tags = icon.tags?.joined(separator: ", ") ?? ""

            return CellView.Model(
                iconID: iconID,
                maxSize: "\(sizeWidth)x\(sizeHeight)",
                tags: tags,
                buttonText: "Download",
                imageURL: downloadURL
            )
        }

        let viewModel = AlphaView.Model(items: items)
        view?.update(model: viewModel)
    }
}
