
import Foundation

protocol DataServiceProtocol {
    func fetchIcons(query: String, count: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void)
    //func prepareImageDownload(query: String, completion: @escaping (Result<IconsResponse, Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    private let dataLoader: DataLoaderProtocol
    
    init(dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }
    
    func fetchIcons(query: String, count: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void) {
        guard let request = APIEndpoint.searchIcons(query: query, count: count).makeRequest() else {
            completion(.failure(NSError(domain: "Invalid request", code: 2)))
            return
        }
        
        dataLoader.fetchData(url: request) { (result: Result<IconsResponse, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func prepareImageDownload(query: String, completion: @escaping (Result<String, Error>) -> Void) {
        let apiendpointer = APIEndpoint(path: "", queryItem: [])
        guard let request = apiendpointer.makeRequestLoadingImage(loadingLink: query) else {
            completion(.failure(NSError(domain: "Invalid request", code: 2)))
            return
        }
        
        dataLoader.fetchData(url: request) { (result: Result<String, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
