import Foundation

class AtomicBool {
    private let queue = DispatchQueue(label: "AtomicBool")
    private var value: Bool
    init (_ data: Bool) {
        self.value = data
    }
    func get() -> Bool {
        return queue.sync { self.value }
    }
    func set(_ data: Bool) {
        queue.sync { self.value = data }
    }
}
