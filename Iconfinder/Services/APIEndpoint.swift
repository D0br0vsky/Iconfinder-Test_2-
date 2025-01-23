
import Foundation

struct APIEndpoint {
    let path: String
    let queryItem: [URLQueryItem]
    
    func makeRequest() -> URLRequest? {
        guard var components = URLComponents(string: "https://api.iconfinder.com/v4\(path)") else {
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
            "Authorization": "Bearer JgVog6mt6EMHpy7ex9hoFOv3zcn6j85JhZBko7jVM1eLjAlJasZRSXqG7SYbvAsM"
        ]
        return request
    }
    
    func makeRequestLoadingImage(loadingLink: String) -> URLRequest? {
        guard var components = URLComponents(string: loadingLink) else {
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
            "Authorization": "Bearer JgVog6mt6EMHpy7ex9hoFOv3zcn6j85JhZBko7jVM1eLjAlJasZRSXqG7SYbvAsM"
        ]
        return request
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
