import Foundation

protocol RestServiceProtocol {
    func loadIcons(count: Int, premium: Bool, vector: Bool, query: String, completion: @escaping (Result<[Icon], NetworkError>) -> Void)
}

final class RestService: RestServiceProtocol {

    func loadIcons(count: Int, premium: Bool, vector: Bool, query: String, completion: @escaping (Result<[Icon], NetworkError>) -> Void) {
        // Создаем URL для поиска иконок
        guard var components = URLComponents(string: "https://api.iconfinder.com/v4/icons/search") else {
            completion(.failure(.invalidURL))
            return
        }

        // Добавляем параметры запроса
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "premium", value: premium ? "true" : "false"),
            URLQueryItem(name: "vector", value: vector ? "true" : "false")
        ]

        // Проверяем финальный URL
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }

        // Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer JgVog6mt6EMHpy7ex9hoFOv3zcn6j85JhZBko7jVM1eLjAlJasZRSXqG7SYbvAsM", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10

        // Отправляем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Обрабатываем ошибку запроса
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.unknown(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response: \(response.debugDescription)")
                completion(.failure(.invalidResponse))
                return
            }

            if httpResponse.statusCode != 200 {
                print("HTTP status code: \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                completion(.failure(.invalidResponse))
                return
            }

            // Проверяем наличие данных
            guard let data = data else {
                print("No data received.")
                completion(.failure(.noData))
                return
            }

            // Декодируем данные
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let searchResult = try decoder.decode(SearchResult.self, from: data)
                completion(.success(searchResult.icons))
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed JSON: \(jsonString)")
                }
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}




/// Первый вариант.
/*
final class RestService: RestServiceProtocol {
    
    func loadIcons(completion: @escaping (Result<[Icon], NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.iconfinder.com/v4/iconsets") else {
            completion(.failure(.invalidURL))
            return
        }
        var reqest = URLRequest(url: url)
        reqest.setValue("Bearer JgVog6mt6EMHpy7ex9hoFOv3zcn6j85JhZBko7jVM1eLjAlJasZRSXqG7SYbvAsM", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: reqest) { data, responce, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            guard let httpResponce = responce as? HTTPURLResponse, httpResponce.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let searchResult = try decoder.decode(SearchResult.self, from: data)
                completion(.success(searchResult.icons))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    
    func searchIcons(with query: String, completion: @escaping (Result<[Icon], NetworkError>) -> Void) {
        let urlString = "https://api.iconfinder.com/v4/icons/search?query=\(query)&count=20"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer JgVog6mt6EMHpy7ex9hoFOv3zcn6j85JhZBko7jVM1eLjAlJasZRSXqG7SYbvAsM", forHTTPHeaderField: "Authorization") // Замените на ваш токен

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.custom(error.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let searchResult = try decoder.decode(SearchResult.self, from: data)
                completion(.success(searchResult.icons))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}
*/


