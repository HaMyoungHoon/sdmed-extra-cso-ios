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
        ZStack {
            VStack(spacing: 10) {
                topContainer.padding(.top, 5)
                infoContainer.padding(.top, 10)
                fileContainer.padding(.top, 10).frame(height: 150, alignment: .top)
                hospitalContainer.padding(.top, 20)
                if let _ = dataContext.selectedHos {
                    pharmaContainer.padding(.top, 10)
                }
            }.padding(10)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            dataContext.addEventListener(self)
            eventWatch()
            checkStoragePK()
            getData()
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
        }.fullScreenCover(isPresented: Binding<Bool>(
            get: { dataContext.mediaViewModel != nil },
            set: { newValue in if !newValue { dataContext.mediaViewModel = nil } }
        )) {
            if let item = dataContext.mediaViewModel {
                MediaViewDialog(dataContext.appState, item)
            }
        }.fullScreenCover(isPresented: Binding<Bool>(
            get: { dataContext.userFileSelect != nil },
            set: { newValue in if !newValue {  } }
        )) {
            if let _ = dataContext.userFileSelect {
                MediaPickerDialog(dataContext.appState, {
                    userFileUpload($0)
                }, 1)
            }
        }.fullScreenCover(isPresented: Binding<Bool>(
            get: { dataContext.mediaViewModelIndex != nil },
            set: { newValue in if !newValue { dataContext.mediaViewModelIndex = nil } }
        )) {
            if let index = dataContext.mediaViewModelIndex {
                MediaViewListDialog(dataContext.appState, dataContext.getMediaList(), index)
            }
        }
    }
    var topContainer: some View {
        Group {
            ZStack {
                HStack {
                    Text(dataContext.thisData.name)
                    Spacer()
                }
                Text(dataContext.thisData.id)
                    .foregroundColor(FAppColor.accent)
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    Spacer()
                    Button(action: { dataContext.relayCommand.execute(MyViewVM.ClickEvent.LOGOUT) }) {
                        Text(FAppLocalString.logoutDesc)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                    }
                    .background(FAppColor.buttonBackground)
                    .foregroundColor(FAppColor.buttonForeground)
                    .cornerRadius(5)
                }
            }
        }
    }
    var infoContainer: some View {
        Group {
            HStack {
                Button(action: { dataContext.relayCommand.execute(MyViewVM.ClickEvent.PASSWORD_CHANGE) }) {
                    Text(FAppLocalString.passwordChangeDesc)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                }
                .background(FAppColor.buttonBackground)
                .foregroundColor(FAppColor.buttonForeground)
                .cornerRadius(5)
                Spacer()
                Button(action: { dataContext.relayCommand.execute(MyViewVM.ClickEvent.MULTI_LOGIN) }) {
                    Text(FAppLocalString.multiLogin)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                }
                .background(FAppColor.buttonBackground)
                .foregroundColor(FAppColor.buttonForeground)
                .cornerRadius(5)
            }
        }
    }
    var fileContainer: some View {
        Group {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    VStack {
                        FImageUtils.asyncImage(dataContext.thisData.trainingUrl, dataContext.thisData.trainingMimeType)
                            .frame(width: 100, height: 100)
                            .onTapGesture { dataContext.relayCommand.execute(MyViewVM.ClickEvent.IMAGE_TRAINING) }
                        Text(dataContext.thisData.trainingDate)
                        Button(action: { dataContext.relayCommand.execute(MyViewVM.ClickEvent.IMAGE_TRAINING_ADD) }) {
                            Text(FAppLocalString.trainingCertificateAdd)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                        }
                        .background(FAppColor.buttonBackground)
                        .foregroundColor(FAppColor.buttonForeground)
                        .cornerRadius(5)
                        Spacer()
                    }
                    VStack {
                        FImageUtils.asyncImage(dataContext.thisData.taxPayerUrl, dataContext.thisData.taxPayerMimeType)
                            .frame(width: 100, height: 100)
                            .onTapGesture { dataContext.relayCommand.execute(MyViewVM.ClickEvent.IMAGE_TAXPAYER) }
                        Text(dataContext.thisData.companyName)
                        Text(dataContext.thisData.companyNumber)
                        Spacer()
                    }
                    VStack {
                        FImageUtils.asyncImage(dataContext.thisData.csoReportUrl, dataContext.thisData.csoReportMimeType)
                            .frame(width: 100, height: 100)
                            .onTapGesture { dataContext.relayCommand.execute(MyViewVM.ClickEvent.IMAGE_CSO_REPORT) }
                        Text(dataContext.thisData.csoReportNumber)
                        Spacer()
                    }
                    VStack {
                        FImageUtils.asyncImage(dataContext.thisData.bankAccountUrl, dataContext.thisData.bankAccountMimeType)
                            .frame(width: 100, height: 100)
                            .onTapGesture { dataContext.relayCommand.execute(MyViewVM.ClickEvent.IMAGE_BANK_ACCOUNT) }
                        Text(dataContext.thisData.bankAccount)
                        Spacer()
                    }
                    VStack {
                        FImageUtils.asyncImage(dataContext.thisData.marketingContractUrl, dataContext.thisData.marketingContractMimeType)
                            .frame(width: 100, height: 100)
                            .onTapGesture { dataContext.relayCommand.execute(MyViewVM.ClickEvent.IMAGE_MARKETING_CONTRACT) }
                        Text(dataContext.thisData.contractDateString)
                        Spacer()
                    }
                }
                .frame(alignment: .topLeading)
            }
        }
    }
    var hospitalContainer: some View {
        Group {
            VStack {
                Text(FAppLocalString.ownHospitalListDesc)
                    .foregroundColor(FAppColor.foreground)
                    .padding(5)
                ScrollView {
                    LazyVStack {
                        ForEach(dataContext.thisData.hosList, id: \.thisPK) { item in
                            hospitalItemContainer(item)
                        }
                    }
                }
            }
        }
    }
    @ViewBuilder
    func hospitalItemContainer(_ item: ExtraMyInfoHospital) -> some View {
        Group {
            VStack {
                Text(item.orgName)
                    .foregroundColor(FAppColor.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !item.address.isEmpty {
                    Text(item.address)
                        .foregroundColor(FAppColor.foreground)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.onTapGesture {
                item.onClick(ExtraMyInfoHospital.ClickEvent.THIS, ExtraMyInfoHospital.self)
            }.frame(maxWidth: .infinity, alignment: .leading)
                .background(dataContext.selectedHos?.thisPK == item.thisPK ? FAppColor.buttonBackground : FAppColor.transparent)
        }
    }
    var pharmaContainer: some View {
        Group {
            VStack {
                Text(FAppLocalString.ownPharmaListDesc)
                    .foregroundColor(FAppColor.foreground)
                    .padding(5)
                ScrollView {
                    if let pharmaList = dataContext.selectedHos?.pharmaList {
                        LazyVStack {
                            ForEach(pharmaList, id:\.thisPK) { item in
                                pharmaItemContainer(item)
                            }
                        }
                    }
                }
            }
        }
    }
    @ViewBuilder
    func pharmaItemContainer(_ item: ExtraMyInfoPharma) -> some View {
        Group {
            VStack {
                Text(item.orgName)
                    .foregroundColor(FAppColor.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !item.address.isEmpty {
                    Text(item.address)
                        .foregroundColor(FAppColor.foreground)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.onTapGesture {
                item.onClick(ExtraMyInfoPharma.ClickEvent.THIS, ExtraMyInfoPharma.self)
            }.frame(maxWidth: .infinity, alignment: .leading)
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
        setHosCommand(data)
    }
    
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? MyViewVM.ClickEvent else { return }
        switch eventName {
        case MyViewVM.ClickEvent.LOGOUT: logout()
            break
        case MyViewVM.ClickEvent.PASSWORD_CHANGE: passwordChange()
            break
        case MyViewVM.ClickEvent.MULTI_LOGIN: multiLogin()
            break
        case MyViewVM.ClickEvent.IMAGE_TRAINING_ADD: imageTrainingAdd()
            break
        case MyViewVM.ClickEvent.IMAGE_TRAINING: imageTraining()
            break
        case MyViewVM.ClickEvent.IMAGE_TAXPAYER: imageTaxpayer()
            break
        case MyViewVM.ClickEvent.IMAGE_BANK_ACCOUNT: imageBankAccount()
            break
        case MyViewVM.ClickEvent.IMAGE_CSO_REPORT: imageCSOReport()
            break
        case MyViewVM.ClickEvent.IMAGE_MARKETING_CONTRACT: imageMarketingContract()
            break
        }
    }
    func setHosCommand(_ data: Any?) {
        guard let array = data as? [Any], array.count > 1,
              let eventName = array[0] as? ExtraMyInfoHospital.ClickEvent,
              let dataBuff = array[1] as? ExtraMyInfoHospital else { return }
        switch eventName {
        case ExtraMyInfoHospital.ClickEvent.THIS:
            if dataContext.selectedHos?.thisPK == dataBuff.thisPK {
                dataContext.selectedHos = nil
            } else {
                dataContext.selectedHos = dataBuff
            }
            break
        }
    }
    
    func getData() {
        dataContext.loading()
        Task {
            let ret = await dataContext.getData()
            dataContext.loading(false)
            if ret.result != true {
                dataContext.toast(ret.msg)
            }
        }
    }
    func logout() {
        dataContext.mqttDisconnect()
        FAmhohwa.logout()
        dataContext.appState.updateToken()
    }
    func passwordChange() {
        dataContext.pwChangeVisible = true
    }
    func multiLogin() {
        dataContext.multiLoginVisible = true
    }
    func imageTrainingAdd() {
        dataContext.trainingListVisible = true
    }
    func imageTraining() {
        dataContext.mediaViewModelIndex = 0
    }
    func imageTaxpayer() {
        if let url = dataContext.thisData.taxPayerUrl {
            dataContext.mediaViewModel = MediaViewModel().apply {
                $0.blobUrl = url
                $0.mimeType = dataContext.thisData.taxPayerMimeType ?? ""
                $0.originalFilename = dataContext.thisData.taxPayerFilename ?? ""
            }
        } else {
            dataContext.userFileSelect = UserFileType.Taxpayer
        }
    }
    func imageBankAccount() {
        if let url = dataContext.thisData.bankAccountUrl {
            dataContext.mediaViewModel = MediaViewModel().apply {
                $0.blobUrl = url
                $0.mimeType = dataContext.thisData.bankAccountMimeType ?? ""
                $0.originalFilename = dataContext.thisData.bankAccountFilename ?? ""
            }
        } else {
            dataContext.userFileSelect = UserFileType.BankAccount
        }
    }
    func imageCSOReport() {
        if let url = dataContext.thisData.csoReportUrl {
            dataContext.mediaViewModel = MediaViewModel().apply {
                $0.blobUrl = url
                $0.mimeType = dataContext.thisData.csoReportMimeType ?? ""
                $0.originalFilename = dataContext.thisData.csoReportFilename ?? ""
            }
        } else {
            dataContext.userFileSelect = UserFileType.CsoReport
        }
    }
    func imageMarketingContract() {
        if let url = dataContext.thisData.marketingContractUrl {
            dataContext.mediaViewModel = MediaViewModel().apply {
                $0.blobUrl = url
                $0.mimeType = dataContext.thisData.marketingContractMimeType ?? ""
                $0.originalFilename = dataContext.thisData.marketingContractFilename ?? ""
            }
        } else {
            dataContext.userFileSelect = UserFileType.MarketingContract
        }
    }
    
    func userFileUpload(_ mediaList: [MediaPickerSourceBuffModel]) {
        dataContext.userFileUpload(mediaList)
    }
}
