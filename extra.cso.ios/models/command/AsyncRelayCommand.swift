import Foundation

class AsyncRelayCommand: PCommand {
    private var _lastClickedTime: Int = 0
    private let _isEnabled = AtomicBool(true)
    var clickIntervalMillis: Int = 250
    var isEnabled: Bool {
        return _isEnabled.get()
    }
    var asyncEvent: PAsyncEventListener? = nil
    let _execute: (Any?) async -> Void
    let _canExecute: ((Any?) -> Bool)?
    init(_ execute: @escaping (Any?) async -> Void, _ canExecute: ((Any?) -> Bool)? = nil) {
        _isEnabled.set(true)
        _execute = execute
        _canExecute = canExecute
        _ = isSafe()
    }
    func execute(_ params: Any?) {
        if !isSafe() {
            return
        }
        if _canExecute?(params) != true && !getEnable() {
            return
        }
        setEnable(false)
        Task {
            await _execute(params)
            await asyncEvent?.onEvent(params)
            setEnable(true)
        }
    }
    
    private func setEnable(_ data: Bool) {
        _isEnabled.set(data)
    }
    private func getEnable() -> Bool {
        return _isEnabled.get()
    }
    open func notifyCanExecuteChanged() {
    }
    func addEventListener(_ listener: PAsyncEventListener) {
        asyncEvent = listener
    }
    private func isSafe() -> Bool {
        let currentTime = Int(Date().timeIntervalSince1970)
        if currentTime - _lastClickedTime > clickIntervalMillis {
            _lastClickedTime = currentTime
            return true
        }
        return false
    }
}
