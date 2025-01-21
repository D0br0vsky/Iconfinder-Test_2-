import Foundation

protocol IsCancelled: Any {
    var isCancelled: Bool { get }
}

extension DispatchWorkItem: IsCancelled { }

protocol CancellableExecutorProtocol: AnyObject {
    func execute(delay: DispatchTimeInterval, handler: @escaping (IsCancelled) -> Void)
    func cancel()
}

final class CancellableExecutor: CancellableExecutorProtocol {
    private let queue: DispatchQueue
    private var pendingWorkItem: DispatchWorkItem?

    deinit {
        cancel()
    }

    init(queue: DispatchQueue = .main) {
        self.queue = queue
    }
    
    func execute(delay: DispatchTimeInterval, handler: @escaping (IsCancelled) -> Void) {
        cancel()
        var workItem: DispatchWorkItem?
        workItem = DispatchWorkItem {
            handler(workItem ?? StubIsCancelled(isCancelled: true))
            workItem = nil
        }
        
        pendingWorkItem = workItem
        workItem.map {
            queue.asyncAfter(deadline: .now() + delay, execute: $0)
        }
    }

    func cancel() {
        pendingWorkItem?.cancel()
        pendingWorkItem = nil
    }
}

private extension CancellableExecutor {
    struct StubIsCancelled: IsCancelled {
        let isCancelled: Bool
    }
}
