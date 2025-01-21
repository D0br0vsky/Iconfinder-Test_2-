
import Foundation

protocol DataServiceProtocol {
    func fetchIcons(query: String, count: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    private let cacheManager: CacheManagerProtocol
    private let dataLoader: DataLoaderProtocol
    
    init(dataLoader: DataLoaderProtocol, cacheManager: CacheManagerProtocol) {
        self.dataLoader = dataLoader
        self.cacheManager = cacheManager
    }
    
    func fetchIcons(query: String, count: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void) {
        let cacheKey = "icons_\(query)_\(count)"
        
        if let cacheData = cacheManager.getCachedResponse(for: cacheKey) {
            do {
                let decodeData = try JSONDecoder().decode(IconsResponse.self, from: cacheData)
                completion(.success(decodeData))
                return
            } catch {
                completion(.failure(error))
            }
        }
        
        guard let request = APIEndpoint.searchIcons(query: query, count: count).makeRequest() else {
            completion(.failure(NSError(domain: "Invalid request", code: 2)))
            return
        }
        
        dataLoader.fetchData(url: request) { [weak self] (result: Result<IconsResponse, Error>) in
            switch result {
            case .success(let data):
                if let jsonData = try? JSONEncoder().encode(data) {
                    self?.cacheManager.saveResponse(jsonData, for: cacheKey)
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
