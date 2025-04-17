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
                    Spacer().frame(height: 100)
                    Text("login_title_desc")
                    Spacer()
                    TextField("login_id_edit_desc", text: $dataContext.id)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 20)
                    SecureField("login_pw_edit_desc", text: $dataContext.pw)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    Button("login_btn_desc") {
                        self.dataContext.relayCommand.execute(LoginViewVM.ClickEvent.LOGIN)
                    }.padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                    Spacer().frame(height: 60)
                }
            }
        }.onAppear {
            dataContext.addEventListener(self)
        }
    }
    
    func onEvent(_ data: Any?) async {
        guard let eventName = data as? LoginViewVM.ClickEvent else { return }
        switch eventName {
            case LoginViewVM.ClickEvent.LOGIN:
            signIn()
            break
        }
    }
    
    func signIn() {
        dataContext.signIn()
    }
}
