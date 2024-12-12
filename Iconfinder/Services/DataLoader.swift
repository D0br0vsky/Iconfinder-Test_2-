
import Foundation

final class DataLoader {
    func fetchData(completion: @escaping (SearchResult) -> Void) {
        let url = URL(string: "https://api.iconfinder.com/v4/icons/search")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "query", value: "arrow"),
          URLQueryItem(name: "count", value: "10"),
          URLQueryItem(name: "premium", value: "false"),
          URLQueryItem(name: "vector", value: "false"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer JgVog6mt6EMHpy7ex9hoFOv3zcn6j85JhZBko7jVM1eLjAlJasZRSXqG7SYbvAsM"
        ]

        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            guard let data else { return }
            if let iconDTO = try? JSONDecoder().decode(SearchResult.self, from: data) {
                print("good")
            } else {
                print("error")
            }
        }
        task.resume()
    }
}
