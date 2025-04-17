import Foundation

class LoginViewVM: FBaseViewModel {
    @Published var id: String = ""
    @Published var pw: String = ""
    
    override init(_ appState: FAppState) {
        super.init(appState)
    }
    
    func signIn() {
        appState.isLoading = true
        Task {
            let ret = await commonService.signIn(id, pw)
            self.appState.isLoading = false
            if ret.result == true {
                FRestVariable.ins.token = ret.data
                FStorage.setAuthToken(ret.data)
                FAmhohwa.addLoginData()
                appState.updateToken()
                return
            }
            self.appState.toastMessage = ret.msg
        }
    }
    
    enum ClickEvent: Int, CaseIterable {
        case LOGIN = 0
    }
}
