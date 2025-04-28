class FDataModelClass<T> where T: CaseIterable {
    var relayCommand: PCommand? = nil
    open func onClick<T1>(_ eventName: T, _ type: T1.Type) {
        relayCommand?.execute([eventName, self as! T1])
    }
    open func onLongClick<T1>(_ eventName: T, _ type: T1.Type) -> Bool {
        relayCommand?.execute([eventName, self as! T1])
        return true
    }
    open func onClickThis(_ eventName: T, _ item: Any) {
        relayCommand?.execute([eventName, item])
    }
    
    open func apply<T1>(_ block: (T1) -> Void) -> T1 {
        block(self as! T1)
        return self as! T1
    }
}
