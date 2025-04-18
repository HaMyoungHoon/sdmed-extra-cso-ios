import Foundation


class LoginDialogVM: FBaseViewModel {
    @Published var id: String = ""
    @Published var pw: String = ""
    var signAble: Bool {
        return id.count >= 3 && pw.count >= 4
    }

    func signIn() async -> RestResultT<String> {
        loading()
        let ret = await commonService.signIn(id, pw)
        loading(false)
        if ret.result == true {
            FRestVariable.ins.token = ret.data
            FStorage.setAuthToken(ret.data)
            FAmhohwa.addLoginData()
            appState.updateToken()
        } else {
            toast(ret.msg)
        }
        return ret
    }
    
    enum ClickEvent: Int, CaseIterable {
        case LOGIN = 0
    }
}
