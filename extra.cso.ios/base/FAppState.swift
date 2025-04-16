import Foundation

enum LaunchState {
    case None
    case Launching
    case Authenticated
}

@MainActor
class FAppState: ObservableObject {
    @Published var launchState: LaunchState = LaunchState.None
    
    func checkAuthToken() {
        if FRestVariable.ins.token == nil {
            if !FAmhohwa.tokenCheck() {
                FAmhohwa.tokenRefresh { ret in
                    
                }
            } else {
                self.launchState = FRestVariable.ins.tokenValid ? LaunchState.Authenticated : LaunchState.Launching
            }
        }
    }
}
