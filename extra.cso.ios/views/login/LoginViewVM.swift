import Foundation

class LoginViewVM: FBaseViewModel {
    @Published var id: String = ""
    @Published var pw: String = ""
    @Published var multiLogin: [UserMultiLoginModel] = []
    @Published var multiLoginVisible = false
    @Published var loginDialogVisible: Bool = false
    
    var signAble: Bool {
        return id.count >= 3 && pw.count >= 4
    }
    
    override init(_ appState: FAppState) {
        super.init(appState)
    }
    
    func showMultiLogin() {
        multiLoginVisible = true
    }
    func signIn() {
        loading()
        Task {
            let ret = await commonService.signIn(id, pw)
            loading(false)
            if ret.result == true {
                FRestVariable.ins.token = ret.data
                FStorage.setAuthToken(ret.data)
                FAmhohwa.addLoginData()
                appState.updateToken()
                return
            }
            toast(ret.msg)
        }
    }
    
    enum ClickEvent: Int, CaseIterable {
        case LOGIN = 0
        case MULTI_LOGIN = 1
    }
}
