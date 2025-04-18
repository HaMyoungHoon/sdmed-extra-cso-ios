import SwiftUI

struct LoginView: FBaseView {
    @StateObject var dataContext: LoginViewVM
    
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: LoginViewVM(appState))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    topContainer
                    Spacer()
                    loginFieldContainer
                    Spacer()
                    loginButtonContainer
                }
            }
            .disabled(dataContext.loginDialogVisible)
        }.onAppear {
            dataContext.addEventListener(self)
            dataContext.multiLogin = FStorage.getMultiLoginData() ?? []
        }.sheet(isPresented: $dataContext.multiLoginVisible) {
            MultiLoginDialog(dataContext.appState, $dataContext.loginDialogVisible)
                .presentationDetents([.fraction(0.3), .medium, .large])
                .presentationDragIndicator(.visible)
        }.overlay {
            if dataContext.loginDialogVisible {
                LoginDialog(dataContext.appState, { dataContext.loginDialogVisible = false })
            }
        }
    }
    var topContainer: some View {
        Group {
            Spacer().frame(height: 100)
            Text("login_title_desc")
        }
    }
    var loginFieldContainer: some View {
        Group {
            TextField("login_id_edit_desc", text: $dataContext.id)
                .textFieldStyle(.roundedBorder)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(FAppColor.border, lineWidth: 1))
            SecureField("login_pw_edit_desc", text: $dataContext.pw)
                .textFieldStyle(.roundedBorder)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(FAppColor.border, lineWidth: 1))
            if !dataContext.multiLogin.isEmpty {
                HStack {
                    Spacer()
                    Button(action: { dataContext.relayCommand.execute(LoginViewVM.ClickEvent.MULTI_LOGIN) }) {
                        Text("multi_login")
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                    }
                    .background(FAppColor.buttonBackground)
                    .foregroundColor(FAppColor.buttonForeground)
                    .cornerRadius(5)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    var loginButtonContainer: some View {
        Group {
            Button(action: { dataContext.relayCommand.execute(LoginViewVM.ClickEvent.LOGIN) }) {
                Text("login_btn_desc")
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
            }
            .background(dataContext.signAble ? FAppColor.buttonBackground : FAppColor.disableBackground)
            .foregroundColor(dataContext.signAble ? FAppColor.buttonForeground : FAppColor.disableForeground)
            .cornerRadius(5)
            Spacer().frame(height: 60)
        }
    }
    
    func onEvent(_ data: Any?) async {
        guard let eventName = data as? LoginViewVM.ClickEvent else { return }
        switch eventName {
            case LoginViewVM.ClickEvent.LOGIN:
            signIn()
            break
            case LoginViewVM.ClickEvent.MULTI_LOGIN:
            multiLogin()
            break
        }
    }
    
    func signIn() {
        if dataContext.signAble == false {
            return
        }
        
        dataContext.signIn()
    }
    func multiLogin() {
        dataContext.showMultiLogin()
    }
}
