
import Foundation

protocol CacheManagerProtocol {
    func getCachedResponse(for key: String) -> Data?
    func saveResponse(_ data: Data, for key: String)
}

final class CacheManager: CacheManagerProtocol {
    private let cache = NSCache<NSString, NSData>()
    
    func getCachedResponse(for key: String) -> Data? {
        return cache.object(forKey: NSString(string: key)) as? Data
    }
    
    func saveResponse(_ data: Data, for key: String) {
        cache.setObject(data as NSData, forKey: NSString(string: key))
    }
}
