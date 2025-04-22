import Foundation

class QueueLockModel<T> {
    var lock = NSLock()
    var queue: [T] = []
    var thread: DispatchQueue
    
    init(_ threadName: String) {
        thread = DispatchQueue(label: threadName)
    }
    
    func locking() {
        lock.lock()
    }
    func unlocking() {
        lock.unlock()
    }
    func findQ(_ locking: Bool = true, _ predicate: (T) -> Bool) -> T? {
        if locking { lock.lock() }
        let ret = queue.first(where: predicate)
        if locking { lock.unlock() }
        return ret
    }
    func removeQ(_ data: T, _ locking: Bool = false) -> Bool where T: Equatable {
        if locking { lock.lock() }
        let ret: Bool
        if let index = queue.firstIndex(of: data) {
            queue.remove(at: index)
            ret = true
        } else {
            ret = false
        }
        if locking { lock.unlock() }
        return ret
    }
    func isEmpty(_ locking: Bool = true) -> Bool {
        if locking { lock.lock() }
        let ret = queue.isEmpty
        if locking { lock.unlock() }
        return ret
    }
    func isNotEmpty(_ locking: Bool = true) -> Bool {
        return !isEmpty(locking)
    }
    func dequeue(_ locking: Bool = true, _ fn: (() -> Void)? = nil) -> T? {
        if locking { lock.lock() }
        let result = queue.isEmpty ? nil : queue.removeFirst()
        fn?()
        if locking { lock.unlock() }
        return result
    }
    func enqueue(_ data: T, _ locking: Bool = true, _ fn: (() -> Void)? = nil) {
        if locking { lock.lock() }
        queue.append(data)
        fn?()
        if locking { lock.unlock() }
    }
    func threadStart(_ fn: @escaping () -> Void, _ skip: Bool = false) {
        guard !skip else { return }
        thread.async {
            fn()
        }
    }
    func threadStart(_ runnable: @escaping () -> Void) {
        thread.async(execute: runnable)
    }
}
