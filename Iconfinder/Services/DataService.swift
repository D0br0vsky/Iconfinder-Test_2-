import Foundation

protocol DataServiceProtocol: AnyObject {
    func fetchIcons(query: String, count: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void)
    func downloadImage(from url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    private let dataLoader: DataLoaderProtocol
    private let dataDecoder: DataDecoderProtocol
    
    init(dataLoader: DataLoaderProtocol, dataDecoder: DataDecoderProtocol) {
        self.dataLoader = dataLoader
        self.dataDecoder = dataDecoder
    }
    
    func fetchIcons(query: String, count: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void) {
        guard let request = APIEndpoint.searchIcons(query: query, count: count).makeRequest() else {
            completion(.failure(NSError(domain: "Invalid request", code: 2)))
            return
        }
        
        dataLoader.fetchData(url: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let decodedResult: Result<IconsResponse, Error> = dataDecoder.decode(data)
                completion(decodedResult)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImage(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let apiEndpoint = APIEndpoint(path: "", queryItem: [])
        guard let request = apiEndpoint.makeRequestLoadingImage(loadingLink: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        dataLoader.fetchData(url: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
