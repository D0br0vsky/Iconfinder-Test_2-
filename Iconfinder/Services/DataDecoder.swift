import Foundation

protocol DataDecoderProtocol: AnyObject {
    func decode<U: Decodable>(_ data: Data) -> Result<U, Error>
}

final class DataDecoder: DataDecoderProtocol {
    func decode<U>(_ data: Data) -> Result<U, any Error> where U: Decodable {
        do {
            let decodedData = try JSONDecoder().decode(U.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
}
