import Foundation

class PasswordChangeDialogVM: FBaseViewModel {
    var myInfoService = FDI.myInfoService
    @Published var currentPW = ""
    @Published var afterPW = ""
    @Published var confirmPW = ""
    @Published var changeAble = false
    @Published var afterPWRuleVisible = false
    @Published var confirmPWRuleVisible = false
    @Published var pwUnMatchVisible = false
    
    func putPasswordChange() async -> RestResultT<ExtraMyInfoResponse> {
        let ret = await myInfoService.putPasswordChange(currentPW, afterPW, confirmPW)
        return ret
    }
    
    func checkChange() {
        pwUnMatchVisible = afterPW != confirmPW
        changeAble = !pwUnMatchVisible && !afterPWRuleVisible && !confirmPWRuleVisible && currentPW.count > 3 && !afterPW.isEmpty && !confirmPW.isEmpty
    }
    
    enum ClickEvent: Int, CaseIterable {
        case CHANGE = 0
    }
}
