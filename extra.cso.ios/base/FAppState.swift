import Foundation
import SwiftUI

enum LaunchState {
    case None
    case Launching
    case Authenticated
}

@MainActor
class FAppState: ObservableObject {
    @Published var launchState: LaunchState = LaunchState.None
    @Published var isLoading: Bool = false
    @Published var toastMessage: String? = nil
    @Published var updateVisible: Bool = false
    @AppStorage(FConstants.NOTIFY_INDEX) var notifyIndex: Int = 0
    
    init() {
        checkVersion()
    }
    
    func checkVersion() {
        loading()
        Task {
            let ret = await FDI.commonService.versionCheck(VersionCheckType.IOS)
            loading(false)
            if let versionModel = ret.data?.first(where: { $0.able }) {
                let currentVersion = FAmhohwa.appVersion()
                let check = FVersionControl.checkVersion(versionModel, currentVersion)
                if check == VersionResultType.NEED_UPDATE {
                    self.updateVisible = true
                    return
                }
                self.checkAuthToken()
            }
        }
    }
    func checkAuthToken() {
        if FRestVariable.ins.token == nil {
            if !FAmhohwa.tokenCheck() {
                self.loading()
                FAmhohwa.tokenRefresh { ret in
                    self.loading(false)
                    self.launchState = FRestVariable.ins.tokenValid ? LaunchState.Authenticated : LaunchState.Launching
                    self.mqttInit()
                }
            } else {
                self.launchState = FRestVariable.ins.tokenValid ? LaunchState.Authenticated : LaunchState.Launching
                mqttInit()
            }
        }
    }
    func updateToken() {
        self.launchState = FRestVariable.ins.tokenValid ? LaunchState.Authenticated : LaunchState.Launching
        mqttInit()
    }
    
    private func mqttInit() {
        Task {
            await FDI.mqttBackgroundService.mqttInit()
        }
    }
    
    func loading(_ isVisible: Bool = true) {
        DispatchQueue.main.async {
            self.isLoading = isVisible
        }
    }
    func toast(_ message: String? = nil) {
        DispatchQueue.main.async {
            self.toastMessage = message
        }
    }
}
