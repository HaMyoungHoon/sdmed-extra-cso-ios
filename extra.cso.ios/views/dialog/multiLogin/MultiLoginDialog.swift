import SwiftUI

struct MultiLoginDialog: FBaseView {
    @Environment(\.dismiss) var dismiss
    @StateObject var dataContext: MultiLoginDialogVM
    init(_ appState: FAppState, _ loginDialogVisible: Binding<Bool>, _ addLoginVisible: Bool = false) {
        _dataContext = StateObject(wrappedValue: MultiLoginDialogVM(appState, loginDialogVisible, addLoginVisible))
    }
    
    var body: some View {
        VStack {
            topContainer
            Spacer()
            itemContainer
        }.onAppear {
            dataContext.addEventListener(self)
            dataContext.items = FStorage.getMultiLoginData() ?? []
            dataContext.items.forEach { $0.relayCommand = dataContext.relayCommand }
        }
        .background(Color(.systemBackground))
    }
    var topContainer: some View {
        Group {
            HStack {
                Spacer()
                FAppImage.close
                    .padding(.top, 8)
                    .padding(.trailing, 20)
                    .onTapGesture { dataContext.relayCommand.execute(MultiLoginDialogVM.ClickEvent.CLOSE) }
            }
            Button(action: { dataContext.relayCommand.execute(MultiLoginDialogVM.ClickEvent.ADD) }) {
                Text("add_desc")
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
            }
            .background(FAppColor.buttonBackground)
            .foregroundColor(FAppColor.buttonForeground)
            .cornerRadius(5)
        }
    }
    var itemContainer: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(dataContext.items, id: \.thisPK) { item in
                    HStack {
                        Text(item.name)
                        Button(action: { item.onClick(UserMultiLoginModel.ClickEvent.THIS, UserMultiLoginModel.self) }) {
                            Text("login_btn_desc")
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                        }
                        .background(FAppColor.buttonBackground)
                        .foregroundColor(FAppColor.buttonForeground)
                        .cornerRadius(5)
                    }
                }
            }
            .padding()
        }
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
        setItemCommand(data)
    }
    
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? MultiLoginDialogVM.ClickEvent else { return }
        switch eventName {
        case MultiLoginDialogVM.ClickEvent.CLOSE:
            dismiss()
            break
        case MultiLoginDialogVM.ClickEvent.ADD:
            addLogin()
            dismiss()
            break
        }
    }
    func setItemCommand(_ data: Any?) {
        guard let array = data as? [Any], array.count > 1,
              let eventName = array[0] as? UserMultiLoginModel.ClickEvent,
              let dataBuff = array[1] as? UserMultiLoginModel
        else { return }
        
        switch eventName {
            case UserMultiLoginModel.ClickEvent.THIS:
            multiSign(dataBuff)
            break
        }
    }
    
    func addLogin() {
        dataContext.showLoginDialog()
    }
    
    func multiSign(_ data: UserMultiLoginModel) {
        dataContext.loading()
        Task {
            let ret = await dataContext.multiSign(data.token)
            dataContext.loading(false)
            if ret.result == true {
                dismiss()
            }
        }
    }
}
