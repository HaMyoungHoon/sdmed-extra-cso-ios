import Combine

class FEventBus {
    static let ins = FEventBus()
    let events = PassthroughSubject<PEventList, Never>()
    func emit<T: PEventList>(_ event: T) {
        events.send(event)
    }
    func createEventChannel<T: PEventList>(_ type: T.Type) -> AnyPublisher<T, Never> {
        events.compactMap { $0 as? T }
            .eraseToAnyPublisher()
    }
}
