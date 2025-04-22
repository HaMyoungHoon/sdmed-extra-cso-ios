import Foundation
import SwiftUI

struct PasswordChangeDialog: FBaseView {
    let onDismiss: () -> Void
    let dismissOnTapOutside: Bool
    @StateObject var dataContext: PasswordChangeDialogVM
    init(_ appState: FAppState, _ onDismiss: @escaping () -> Void, _ dismissOnTapOutside: Bool = false) {
        _dataContext = StateObject(wrappedValue: PasswordChangeDialogVM(appState))
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
                pwFieldContainer
                Spacer()
                alertContainer
                pwButtonContainer
            }.frame(width: UIScreen.main.bounds.size.width - 100, height: 400)
                .cornerRadius(20)
                .background(FAppColor.background)
                .padding()
        }.onAppear {
            dataContext.addEventListener(self)
        }.ignoresSafeArea(.all)
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .center)
    }
    
    var pwFieldContainer: some View {
        Group {
            VStack {
                Spacer().frame(height: 10)
                SecureField("current_pw_desc", text: $dataContext.currentPW)
                    .textFieldStyle(.roundedBorder)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(FAppColor.border, lineWidth: 1))
                    .padding(10)
                SecureField("after_pw_desc", text: $dataContext.afterPW)
                    .textFieldStyle(.roundedBorder)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(FAppColor.border, lineWidth: 1))
                    .padding(10)
                SecureField("confirm_desc", text: $dataContext.confirmPW)
                    .textFieldStyle(.roundedBorder)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(FAppColor.border, lineWidth: 1))
                    .padding(10)
            }
            .padding(.top, 20)
        }
    }
    var alertContainer: some View {
        Group {
            VStack {
                if dataContext.afterPWRuleVisible {
                    Text("after_pw_rule_check_desc")
                        .foregroundColor(FAppColor.error)
                }
                if dataContext.confirmPWRuleVisible {
                    Text("confirm_pw_rule_check_desc")
                        .foregroundColor(FAppColor.error)
                }
                if dataContext.pwUnMatchVisible {
                    Text("after_confirm_unmatch_desc")
                        .foregroundColor(FAppColor.error)
                }
            }
        }
    }
    var pwButtonContainer: some View {
        Group {
            Button(action: { dataContext.relayCommand.execute(PasswordChangeDialogVM.ClickEvent.CHANGE) }) {
                Text("password_change_desc")
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
            }
            .background(dataContext.changeAble ? FAppColor.buttonBackground : FAppColor.disableBackground)
            .foregroundColor(dataContext.changeAble ? FAppColor.buttonForeground : FAppColor.disableForeground)
            .cornerRadius(5)
            Spacer().frame(height: 20)
        }
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
    }
    
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? PasswordChangeDialogVM.ClickEvent else { return }
        switch eventName {
        case PasswordChangeDialogVM.ClickEvent.CHANGE:
            change()
            break
        }
    }
    
    func change() {
        if !dataContext.changeAble {
            return
        }
        
        dataContext.loading()
        Task {
            let ret = await dataContext.putPasswordChange()
            dataContext.loading(false)
            if ret.result == true {
                self.onDismiss()
            } else {
                dataContext.toast(ret.msg)
            }
        }
    }
}
