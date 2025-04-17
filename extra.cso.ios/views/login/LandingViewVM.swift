import Foundation
import SwiftUI

class LandingViewVM: FBaseViewModel {
    @Published var visibleLogin = false

    func goToLogin() {
        self.visibleLogin = true
    }
    enum ClickEvent: Int, CaseIterable {
        case LOGIN = 0
    }
}
