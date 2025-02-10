import Foundation

protocol DataLoaderProtocol: AnyObject {
    func fetchData(url: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

final class DataLoader: DataLoaderProtocol {
    func fetchData(url: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid HTTP response", code: (response as? HTTPURLResponse)?.statusCode ?? -1)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
