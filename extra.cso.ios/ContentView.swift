import SwiftUI

struct ContentView: View {
    @StateObject var appState = FAppState()
    var body: some View {
        ZStack {
            loadingView
            updateView
            toastView
            contentView().environmentObject(appState)
        }.onAppear {
            FDI.notificationService.checkPermission()
            appState.checkVersion()
        }
    }
    var loadingView: some View {
        ZStack {
            if appState.isLoading {
                FAppColor.backdrop
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(99)
                ProgressView()
                    .tint(FAppColor.accent)
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
                    .zIndex(100)
            }
        }.zIndex(100)
    }
    var toastView: some View {
        VStack {
            if let toast = appState.toastMessage {
                Text(toast)
                    .padding()
                    .background(FAppColor.scrim)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 5)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                appState.toast()
                            }
                        }
                    }
                Spacer()
            }
        }
        .zIndex(200)
    }
    var updateView: some View {
        VStack {
            if appState.updateVisible {
                Text("new_version_update_desc")
                HStack {
                    Text("update_dsec")
                }
            }
        }.zIndex(101)
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch appState.launchState {
        case LaunchState.None:
            LandingView(appState)
        case LaunchState.Launching:
            LandingView(appState)
        case LaunchState.Authenticated:
            MainView()
        }
    }
}
