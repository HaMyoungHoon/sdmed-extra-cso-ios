class FDataModelClass<T> where T: CaseIterable {
    var relayCommand: PCommand? = nil
    open func onClick(_ eventName: T) {
        relayCommand?.execute([eventName, self])
    }
    open func onLongClick(_ eventName: T) -> Bool {
        relayCommand?.execute([eventName, self])
        return true
    }
}
