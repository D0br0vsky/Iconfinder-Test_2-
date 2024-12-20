
import Foundation

protocol DataServiceProtocol {
    func fetchIcons(query: String, count: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    private let dataLoader: DataLoader
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    func fetchIcons(query: String, count: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void) {
        guard let request = APIEndpoint.searchIcons(query: query, count: count).makeRequest() else {
            completion(.failure(NSError(domain: "Invalid request", code: 2)))
            return
        }
        
        dataLoader.fetchData(url: request, completion: completion)
    }
}
