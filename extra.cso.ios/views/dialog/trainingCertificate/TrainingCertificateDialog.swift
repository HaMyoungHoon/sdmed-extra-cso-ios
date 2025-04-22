import Foundation
import Combine
import SwiftUI

struct TrainingCertificateDialog: FBaseView {
    @Environment(\.dismiss) var dismiss
    @StateObject var dataContext: TrainingCertificateDialogVM
    @State var cancellables = Set<AnyCancellable>()
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: TrainingCertificateDialogVM(appState))
    }
    
    var body: some View {
        ZStack {
            VStack {
                topContainer
                Spacer()
                fileAddContainer
                itemListContainer
            }
        }.onAppear {
            dataContext.addEventListener(self)
            eventWatch()
            getList()
        }.fullScreenCover(isPresented: $dataContext.imageSelect) {
            MediaPickerDialog(dataContext.appState, { dataContext.setUploadBuff($0) }, 1)
        }
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
        }
    }
    var fileAddContainer: some View {
        Group {
            VStack {
                if let buff = dataContext.uploadBuff {
                    HStack {
                        Image(uiImage: buff.thumbnail)
                            .frame(width: 100, height: 100)
                        let locale = FExtensions.ins.getLocalize().toLocale()
                        DatePicker("", selection: $dataContext.trainingDate, displayedComponents: .date)
                            .environment(\.locale, locale)
                            .datePickerStyle(.compact)
                            .background(FAppColor.buttonBackground)
                            .foregroundColor(FAppColor.buttonForeground)
                            .cornerRadius(5)
                            .padding(3)
                            .labelsHidden()
                    }
                    .frame(alignment: .center)
                }
                HStack {
                    Button(action: { dataContext.relayCommand.execute(TrainingCertificateDialogVM.ClickEvent.ADD) }) {
                        Text("add_desc")
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                    }
                    .background(FAppColor.buttonBackground)
                    .foregroundColor(FAppColor.buttonForeground)
                    .cornerRadius(5)
                    Button(action: { dataContext.relayCommand.execute(TrainingCertificateDialogVM.ClickEvent.SAVE) }) {
                        Text("save_desc")
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                    }
                    .background(dataContext.isSavable ? FAppColor.buttonBackground : FAppColor.disableBackground)
                    .foregroundColor(dataContext.isSavable ? FAppColor.buttonForeground : FAppColor.disableForeground)
                    .cornerRadius(5)
                }
            }.frame(maxWidth: .infinity, alignment: .center)
        }
    }
    var itemListContainer: some View {
        Group {
            ScrollView {
                LazyVStack {
                    ForEach(dataContext.trainingList, id: \.thisPK) { item in
                        itemContainer(item)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    @ViewBuilder
    func itemContainer(_ item: UserTrainingModel) -> some View {
        HStack {
            FImageUtils.asyncImage(item.blobUrl, item.mimeType)
                .frame(width: 100, height: 100, alignment: .leading)
            VStack {
                Text(item.trainingDate.toString)
                    .foregroundColor(FAppColor.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.originalFilename)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(FAppColor.foreground)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func eventWatch() {
        FEventBus.ins.createEventChannel(UserFileUploadEvent.self)
            .sink { _ in
                getList()
                dataContext.uploadBuff = nil
            }.store(in: &cancellables)
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
    }
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? TrainingCertificateDialogVM.ClickEvent else { return }
        switch eventName {
        case TrainingCertificateDialogVM.ClickEvent.CLOSE:
            dismiss()
            break
        case TrainingCertificateDialogVM.ClickEvent.TRAINING_DATE:
            break
        case TrainingCertificateDialogVM.ClickEvent.ADD:
            dataContext.imageSelect = true
            break
        case TrainingCertificateDialogVM.ClickEvent.SAVE:
            save()
            break
        }
    }
    
    func getList() {
        dataContext.loading()
        Task {
            let ret = await dataContext.getList()
            dataContext.loading(false)
            if ret.result != true {
                dataContext.toast(ret.msg)
            }
        }
    }
    func save() {
        if !dataContext.isSavable {
            return
        }
        dataContext.toast(FAppLocalString.userFileUpload)
        dataContext.loading()
        dataContext.startBackground()
    }
}
