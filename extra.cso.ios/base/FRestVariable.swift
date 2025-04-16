class FRestVariable {
    static let ins = FRestVariable()    
    var token: String? = nil
    var tokenValid: Bool {
        guard let tokenBuff = token else {
            return false
        }
        
        return tokenBuff.isEmpty == false
    }
    var refreshing = AtomicBool(false)
}
