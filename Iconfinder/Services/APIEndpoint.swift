import Foundation

struct APIEndpoint {
    let path: String
    let queryItem: [URLQueryItem]
    
    func makeRequest() -> URLRequest? {
        return createRequest(urlString: "https://api.iconfinder.com/v4\(path)")
    }
    
    func makeRequestLoadingImage(loadingLink: String) -> URLRequest? {
        return createRequest(urlString: loadingLink)
    }
}

extension APIEndpoint {
    static func searchIcons(query: String, count: Int) -> APIEndpoint {
        return APIEndpoint(
            path: "/icons/search",
            queryItem: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "count", value: "\(count)"),
                URLQueryItem(name: "premium", value: "false"),
                URLQueryItem(name: "vector", value: "false")
            ]
        )
    }
}

// MARK: - Private Methods
private extension APIEndpoint {
    func createRequest(urlString: String) -> URLRequest? {
        guard var components = URLComponents(string: urlString) else {
            return nil
        }
        components.queryItems = queryItem
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 200
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Bundle.main.apiKey)"
        ]
        return request
    }
}
