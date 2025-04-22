import Foundation
import SwiftUI

@MainActor
open class FBaseViewModel: ObservableObject {
    @Published var appState: FAppState
    var myState: UserStatus = UserStatus.None
    var commonService: PCommonRepository = FDI.commonService
    
    init(_ appState: FAppState) {
        self.appState = appState
        fakeInit()
        relayCommand = AsyncRelayCommand(self.execute)
    }
    
    func getMyState() {
        Task {
            let ret = await commonService.getMyState()
            if ret.result == true {
                myState = ret.data ?? UserStatus.None
                return
            }
        }
    }
    
    lazy var relayCommand: PCommand = AsyncRelayCommand(self.execute)
    func addEventListener(_ listener: PAsyncEventListener) {
        (relayCommand as? AsyncRelayCommand)?.addEventListener(listener)
    }
    func loading(_ isVisible: Bool = true) {
        self.appState.loading(isVisible)
    }
    func toast(_ msg: String?) {
        self.appState.toast(msg)
    }
    
    open func execute(_ data: Any?) async -> Void {
    }
    open func fakeInit() {
    }
}
