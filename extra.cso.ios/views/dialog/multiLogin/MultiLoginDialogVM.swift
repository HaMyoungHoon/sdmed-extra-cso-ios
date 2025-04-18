import Foundation
import SwiftUI

class MultiLoginDialogVM: FBaseViewModel {
    @Binding var loginDialogVisible: Bool
    @Published var addLoginVisible: Bool = false
    @Published var items: [UserMultiLoginModel] = []
    init(_ appState: FAppState, _ loginDialogVisible: Binding<Bool>, _ addLoginVisible: Bool = false) {
        _loginDialogVisible = loginDialogVisible
        self.addLoginVisible = addLoginVisible
        super.init(appState)
    }
    
    func showLoginDialog() {
        loginDialogVisible = true
    }
    
    func multiSign(_ token: String) async -> RestResultT<String> {
        let ret = await commonService.multiSign(token)
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
        case CLOSE = 0
        case ADD = 1
    }
}
