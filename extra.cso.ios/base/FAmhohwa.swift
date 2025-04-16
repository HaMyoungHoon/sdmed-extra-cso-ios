import Foundation

class FAmhohwa {
    static func intervalBetweenDate(_ expiredDate: Int?) -> Bool {
        guard let data = expiredDate else {
            return false
        }
        return true
    }
    static func intervalBetweenDate(_ expiredDate: TimeInterval?) -> Bool {
        guard let data = expiredDate else {
            return false
        }
        let now = FDateTime2().setThis(Int(Date().timeIntervalSince1970))
        
        return true
    }
    static func tokenIntervalValid(_ token: String?) -> Bool {
        guard let tokenBuff = token else {
            return false
        }
        if intervalBetweenDate(JWT(tokenBuff).expiredDate) {
            return false
        }
        return true
    }
    static func tokenCheck() -> Bool {
        if FRestVariable.ins.token?.isEmpty != false {
            FRestVariable.ins.token = FStorage.getAuthToken()
        }
        return tokenIntervalValid(FRestVariable.ins.token)
    }
    static func tokenRefresh(_ ret: ((RestResultT<String>) -> Void)? = nil) {
        if FRestVariable.ins.refreshing.get() {
            return
        }
        if !FRestVariable.ins.tokenValid {
            ret?(RestResultT<String>.setFail(""))
            return
        }
        
        FRestVariable.ins.refreshing.set(true)
        Task {
            let buff = await FDI.commonService.tokenRefresh()
            FRestVariable.ins.refreshing.set(false)
            if buff.result == true {
                let newToken = buff.data ?? ""
                if rhsTokenIsMost(newToken) {
                    FStorage.putAuthToken(newToken)
                    addLoginData()
                }
                FRestVariable.ins.token = FStorage.getAuthToken()
            } else {
                if buff.code == -10002 {
                    delLoginData()
                }
                FStorage.removeAuthToken()
                FRestVariable.ins.token = nil
            }
            ret?(buff)
        }
    }
    static func rhsTokenIsMost(_ newToken: String) -> Bool {
        guard let token = FRestVariable.ins.token,
              let previous = JWT(token).expiredDate else {
            return true
        }
        guard let new = JWT(newToken).expiredDate else {
            return false
        }
        return new >= previous
    }
    static func addLoginData() {
        
    }
    static func delLoginData() {
        
    }
    static func removeLoginData() {
        FRestVariable.ins.token = nil
        FStorage.removeAuthToken()
    }
}
