protocol PCommand {
    var isEnabled: Bool { get }
    func execute(_ params: Any?)
    func notifyCanExecuteChanged()
    var asyncEvent: PAsyncEventListener? { get set }
    var clickIntervalMillis: Int { get set }
}
