
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(Error)
    case unknown(Error?)
    case custom(String)
}
