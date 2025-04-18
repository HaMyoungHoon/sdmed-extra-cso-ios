import Foundation
import SwiftUI

struct LoginDialog: FBaseView {
    let onDismiss: () -> Void
    let dismissOnTapOutside: Bool
    @StateObject var dataContext: LoginDialogVM
    init(_ appState: FAppState, _ onDismiss: @escaping () -> Void, _ dismissOnTapOutside: Bool = false) {
        _dataContext = StateObject(wrappedValue: LoginDialogVM(appState))
        self.onDismiss = onDismiss
        self.dismissOnTapOutside = dismissOnTapOutside
    }
    var body: some View {
        ZStack {
            Rectangle()
                .fill(FAppColor.modalBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        onDismiss()
                    }
                }
            VStack {
                loginFieldContainer
                Spacer()
                loginButtonContainer
            }.frame(width: UIScreen.main.bounds.size.width - 100, height: 300)
                .cornerRadius(20)
                .background(FAppColor.background)
                .padding()
        }.onAppear {
            dataContext.addEventListener(self)
        }.ignoresSafeArea(.all)
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .center)
    }
    var loginFieldContainer: some View {
        Group {
            Spacer()
            TextField("login_id_edit_desc", text: $dataContext.id)
                .textFieldStyle(.roundedBorder)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(FAppColor.border, lineWidth: 1))
            SecureField("login_pw_edit_desc", text: $dataContext.pw)
                .textFieldStyle(.roundedBorder)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(FAppColor.border, lineWidth: 1))
        }
        .padding(.horizontal, 20)
    }
    var loginButtonContainer: some View {
        Group {
            Button(action: { dataContext.relayCommand.execute(LoginDialogVM.ClickEvent.LOGIN) }) {
                Text("login_btn_desc")
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
            }
            .background(dataContext.signAble ? FAppColor.buttonBackground : FAppColor.disableBackground)
            .foregroundColor(dataContext.signAble ? FAppColor.buttonForeground : FAppColor.disableForeground)
            .cornerRadius(5)
            Spacer().frame(height: 20)
        }
    }
    
    func onEvent(_ data: Any?) async {
        guard let eventName = data as? LoginDialogVM.ClickEvent else { return }
        switch eventName {
        case LoginDialogVM.ClickEvent.LOGIN:
            signIn()
            break
        }
    }
    func signIn() {
        if dataContext.signAble == false {
            return
        }
        Task {
            let ret = await dataContext.signIn()
            if ret.result == true {
                onDismiss()
            }
        }
    }
}
