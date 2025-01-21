import Foundation

protocol IconsDataHandlerProtocol {
    func processFetchResult(result: Result<[IconDTO], Error>, onSuccess: ([IconDTO]) -> Void, onEmpty: () -> Void, onError: () -> Void)
}

final class IconsDataHandler: IconsDataHandlerProtocol {
    func processFetchResult(result: Result<[IconDTO], Error>, onSuccess: ([IconDTO]) -> Void, onEmpty: () -> Void, onError: () -> Void) {
        switch result {
        case .success(let icons):
            if icons.isEmpty {
                onEmpty()
            } else {
                onSuccess(icons)
            }
        case .failure:
            onError()
        }
    }
}
