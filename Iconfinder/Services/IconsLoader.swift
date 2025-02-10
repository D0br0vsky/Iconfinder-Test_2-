import Foundation

protocol IconsLoaderProtocol: AnyObject {
    func loadIcons(query: String, page: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void)
}

final class IconsLoader: IconsLoaderProtocol {
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func loadIcons(query: String, page: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void) {
        dataService.fetchIcons(query: query, count: 10 * page) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
