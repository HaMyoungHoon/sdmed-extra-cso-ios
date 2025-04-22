import Foundation
import Combine
import SwiftUI

struct MyView: FBaseView {
    @StateObject var dataContext: MyViewVM
    @State var cancellables = Set<AnyCancellable>()
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: MyViewVM(appState))
    }
    
    var body: some View {
        VStack {
            topContainer
            infoContainer
            fileContainer
            hospitalContainer
            pharmaContainer
        }.onAppear {
            dataContext.addEventListener(self)
            eventWatch()
            checkStoragePK()
        }.sheet(isPresented: $dataContext.multiLoginVisible) {
            MultiLoginDialog(dataContext.appState, $dataContext.loginDialogVisible, true)
                .presentationDetents([.fraction(0.3), .medium, .large])
                .presentationDragIndicator(.visible)
        }.sheet(isPresented: $dataContext.trainingListVisible) {
            TrainingCertificateDialog(dataContext.appState)
                .presentationDetents([.fraction(0.3), .medium, .large])
                .presentationDragIndicator(.visible)
        }.overlay {
            if dataContext.loginDialogVisible {
                LoginDialog(dataContext.appState, { dataContext.loginDialogVisible = false })
            }
            if dataContext.pwChangeVisible {
                PasswordChangeDialog(dataContext.appState, { dataContext.pwChangeVisible = false })
            }
        }.fullScreenCover(isPresented: $dataContext.filePickerVisible) {
            
        }
        // fullscreen detail view
        // fullscreen file picker
    }
    var topContainer: some View {
        Group {
            Button(action: { dataContext.relayCommand.execute(MyViewVM.ClickEvent.IMAGE_TRAINING) }) {
                Text(FAppLocalString.trainingCertificateAdd)
            }
        }
    }
    var infoContainer: some View {
        Group {
            
        }
    }
    var fileContainer: some View {
        Group {
            
        }
    }
    var hospitalContainer: some View {
        Group {
            
        }
    }
    @ViewBuilder
    func hospitalItemContainer(_ item: ExtraMyInfoHospital) -> some View {
        Group {
            
        }
    }
    var pharmaContainer: some View {
        Group {
            
        }
    }
    @ViewBuilder
    func pharmaItemContainer(_ item: ExtraMyInfoPharma) -> some View {
        Group {
            
        }
    }
    func eventWatch() {
        FEventBus.ins.createEventChannel(UserFileUploadEvent.self)
            .sink { _ in
                getData()
            }.store(in: &cancellables)
        FEventBus.ins.createEventChannel(MultiLoginEvent.self)
            .sink { _ in
                getData()
            }.store(in: &cancellables)
    }
    func checkStoragePK() {
        FStorage.removeNotifyPK()
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
    }
    
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? MyViewVM.ClickEvent else { return }
        switch eventName {
        case MyViewVM.ClickEvent.LOGOUT:
            break
        case MyViewVM.ClickEvent.PASSWORD_CHANEG:
            break
        case MyViewVM.ClickEvent.MULTI_LOGIN:
            break
        case MyViewVM.ClickEvent.IMAGE_TRAINING:
            dataContext.trainingListVisible = true
            break
        case MyViewVM.ClickEvent.IMAGE_TAXPAYER:
            break
        case MyViewVM.ClickEvent.IMAGE_BANK_ACCOUNT:
            break
        case MyViewVM.ClickEvent.IMAGE_CSO_REPORT:
            break
        case MyViewVM.ClickEvent.IMAGE_MARKETING_CONTRACT:
            break
        }
    }
    
    func getData() {
        
    }
}
