
import Foundation

protocol DataLoaderProtocol {
    func fetchData<U: Decodable>(url: URLRequest, completion: @escaping (Result<U, Error>) -> Void)
}

final class DataLoader: DataLoaderProtocol {
    func fetchData<U: Decodable>(url: URLRequest, completion: @escaping (Result<U, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


