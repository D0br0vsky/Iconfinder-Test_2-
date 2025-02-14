final class DebouncedIconsLoader: IconsLoaderProtocol {
    private let iconsLoader: IconsLoaderProtocol
    private let debouncer = CancellableExecutor(queue: .main)
    
    init(iconsLoader: IconsLoaderProtocol) {
        self.iconsLoader = iconsLoader
    }
    
    func loadIcons(query: String, page: Int, completion: @escaping (Result<IconsResponse, Error>) -> Void) {
        debouncer.execute(delay: .milliseconds(400)) { [weak self] isCancelled in
            guard let self = self, !isCancelled.isCancelled else { return }
            self.iconsLoader.loadIcons(query: query, page: page, completion: completion)
        }
    }
}
