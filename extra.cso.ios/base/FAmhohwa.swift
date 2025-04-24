import Foundation

class FAmhohwa {
    static func getUserID() -> String {
        guard let encoded = getTokenID().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return ""
        }
        return encoded
    }
    static func getUserName() -> String {
        guard let encoded = getTokenName().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return ""
        }
        return encoded
    }
    static func getTokenID() -> String {
        guard let token = FRestVariable.ins.token else {
            return ""
        }
        return JWT(token).subject ?? ""
    }
    static func getTokenName() -> String {
        guard let token = FRestVariable.ins.token else {
            return ""
        }
        return JWT(token).userName ?? ""
    }
    static func getThisPK() -> String {
        guard let token = FRestVariable.ins.token else {
            return ""
        }
        return JWT(token).userPK ?? ""
    }
    static func intervalBetweenDate(_ expiredDate: Int?) -> Bool {
        guard let data = expiredDate else {
            return false
        }
        let expired = FDateTime2().setThis(data)
        let now = FDateTime2().setThis(Int(Date().timeIntervalSince1970)).addDays(-10)
        return expired.getDaysBetween(now) > 0
    }
    static func intervalBetweenDate(_ expiredDate: TimeInterval?) -> Bool {
        guard let data = expiredDate else {
            return false
        }
        return intervalBetweenDate(data.toInt)
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
                    FStorage.setAuthToken(newToken)
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
    static func logout() {
        removeLoginData()
        FStorage.logoutMultiLoginData()
    }
    static func addLoginData() {
        FStorage.addMultiLoginData(UserMultiLoginModel().apply {
            $0.thisPK = getThisPK()
            $0.id = getTokenID()
            $0.name = getTokenName()
            $0.token = FStorage.getAuthToken()
            $0.isLogin = true
        })
    }
    static func delLoginData() {
        FStorage.delMultiLoginData(UserMultiLoginModel().apply {
            $0.thisPK = getThisPK()
            $0.id = getTokenID()
            $0.name = getTokenName()
            $0.token = FStorage.getAuthToken()
            $0.isLogin = true
        })
    }
    static func removeLoginData() {
        FRestVariable.ins.token = nil
        FStorage.removeAuthToken()
    }
    static func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
}
