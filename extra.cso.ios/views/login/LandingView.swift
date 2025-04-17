import SwiftUI

struct LandingView: FBaseView {
    @StateObject var dataContext: LandingViewVM
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: LandingViewVM(appState))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(FAppImage.landingBackgroundNamed)
                    .resizable()
                    .clipped()
                    .ignoresSafeArea()
                VStack {
                    Spacer().frame(height: 100)
                    Text("app_name")
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                    loginButton
                }.padding(.horizontal, 20)
            }.navigationDestination(isPresented: $dataContext.visibleLogin) {
                LoginView(dataContext.appState)
            }
        }.onAppear {
            dataContext.addEventListener(self)
        }
    }
    var loginButton: some View {
        VStack {
            if dataContext.appState.launchState == LaunchState.Launching {
                Button(action: {
                    dataContext.relayCommand.execute(LandingViewVM.ClickEvent.LOGIN)
                }) {
                    Text("login_btn_desc").frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(FAppColor.buttonBackground)
                        .foregroundColor(FAppColor.buttonForeground)
                        .cornerRadius(8)
                }
                Spacer().frame(height: 60)
            }
        }
    }
    
    func onEvent(_ data: Any?) async {
        guard let eventName = data as? LandingViewVM.ClickEvent else { return }
        switch eventName {
            case LandingViewVM.ClickEvent.LOGIN:
            dataContext.goToLogin()
            break
        }
    }
}
