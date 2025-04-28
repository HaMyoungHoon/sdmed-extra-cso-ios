import Foundation
import SwiftUI
import Combine

struct EDIDetailView: FBaseView {
    @Environment(\.dismiss) var dismiss
    @StateObject var dataContext: EDIDetailViewVM
    @State var cancellables = Set<AnyCancellable>()
    init (_ appState: FAppState, _ thisPK: String) {
        _dataContext = StateObject(wrappedValue: EDIDetailViewVM(appState, thisPK))
    }
    var body: some View {
        ZStack {
            VStack {
                topContainer
                ScrollView {
                    pharmaListContainer
                    responseListContainer
                }
            }
        }.onAppear {
            dataContext.addEventListener(self)
            getData()
            eventWatch()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { dataContext.mediaView != nil },
                set: { _ in dataContext.mediaView = nil }
            )) {
                if let mediaView = dataContext.mediaView {
                    MediaViewDialog(dataContext.appState, MediaViewModel().parse(mediaView))
                }
            }
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { dataContext.mediaListView != nil },
                set: { _ in dataContext.mediaListView = nil }
            )) {
                if let mediaListView = dataContext.mediaListView {
                    let items = dataContext.getMediaViewPharmaFiles(mediaListView)
                    let index = items.firstIndex(where: { $0.blobUrl == mediaListView.blobUrl }) ?? 0
                    MediaViewListDialog(dataContext.appState, items, index)
                }
            }
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { dataContext.addPharmaFilePK != nil },
                set: { _ in dataContext.addPharmaFilePK = nil }
            )) {
                if let thisPK = dataContext.addPharmaFilePK {
                    MediaPickerDialog(dataContext.appState, { dataContext.reSetImage(thisPK, $0) }, 0, dataContext.getMedia(thisPK))
                }
            }
            .fullScreenCover(isPresented: $dataContext.hospitalDetailVisible) {
                HospitalTempDetailDialog(dataContext.appState, dataContext.item.tempHospitalPK)
            }
    }
    var topContainer: some View {
        Group {
            ZStack {
                HStack {
                    FAppImage.close
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.top, 8)
                        .padding(.trailing, 20)
                        .onTapGesture { dataContext.relayCommand.execute(EDIDetailViewVM.ClickEvent.CLOSE) }
                        .tint(dataContext.closeAble ? FAppColor.buttonBackground : FAppColor.transparent)
                    Spacer()
                }
                Text(dataContext.item.orgViewName)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.horizontal, 30)
                    .foregroundColor(dataContext.item.tempHospitalPK.isEmpty ? FAppColor.foreground : FAppColor.accent)
                    .onTapGesture {
                        if !dataContext.item.tempHospitalPK.isEmpty {
                            dataContext.relayCommand.execute(EDIDetailViewVM.ClickEvent.HOSPITAL_DETAIL)
                        }
                    }
                HStack {
                    Spacer()
                    ZStack {
                        Text(dataContext.item.ediState.desc.localized)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                    }
                    .background(dataContext.item.ediBackColor)
                    .foregroundColor(dataContext.item.ediColor)
                    .cornerRadius(5)
                }
            }
        }
    }
    var pharmaListContainer: some View {
        Group {
            LazyVStack {
                ForEach(dataContext.item.pharmaList, id: \.thisPK) { item in
                    pharmaItemContainer(item)
                }
            }
        }
    }
    @ViewBuilder
    func pharmaItemContainer(_ item: ExtraEDIPharma) -> some View {
        Group {
            VStack {
                ZStack {
                    HStack {
                        if item.isCarriedOver {
                            Text(FAppLocalString.carriedOverDesc)
                                .foregroundColor(FAppColor.cardParagraph1)
                                .frame(alignment: .leading)
                                .padding(0)
                        }
                        Text(item.yearMonth)
                            .foregroundColor(FAppColor.foreground)
                            .frame(alignment: .leading)
                            .padding(0)
                        Text(item.orgName)
                            .foregroundColor(FAppColor.cardParagraph1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        ZStack {
                            Text(item.ediState.desc.localized)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                        }
                        .background(item.ediState.parseEDIBackColor())
                        .foregroundColor(item.ediState.parseEDIColor())
                        .cornerRadius(5)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { item.onClick(ExtraEDIPharma.ClickEvent.OPEN, ExtraEDIPharma.self) }
                .padding(.top, 5)
                .padding(.leading, 5)
                .padding(.trailing, 5)
                if item.isOpen {
                    pharmaFileContainer(item.fileList)
                    if item.isAddable {
                        pharmaFileUploadContainer(item)
                    }
                }
            }
        }
        .background(FAppColor.cardBackground1)
//        .animation(.easeInOut, value: item.isOpen)
        .cornerRadius(5)
    }
    @ViewBuilder
    func pharmaFileContainer(_ items: [EDIUploadPharmaFileModel]) -> some View {
        Group {
            TabView {
                ForEach(items, id: \.thisPK) { item in
                    FImageUtils.asyncImage(item.blobUrl, item.mimeType)
                        .scaledToFit()
                        .onTapGesture { item.onClick(EDIUploadPharmaFileModel.ClickEvent.SHORT, EDIUploadPharmaFileModel.self) }
                        .onLongPressGesture { item.onClick(EDIUploadPharmaFileModel.ClickEvent.LONG, EDIUploadPharmaFileModel.self) }
                }
            }.tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(height: 300)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(0)
    }
    @ViewBuilder
    func pharmaFileUploadContainer(_ item: ExtraEDIPharma) -> some View {
        Group {
            VStack {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(item.uploadItems, id:\.thisPK) { item in
                            pharmaFileUploadItemContainer(item)
                        }
                    }
                }.frame(maxWidth: .infinity, alignment:.leading)
                HStack {
                    Button(action: { item.onClick(ExtraEDIPharma.ClickEvent.ADD, ExtraEDIPharma.self) }) {
                        Text(FAppLocalString.addDesc)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                    }
                    .background(FAppColor.buttonBackground)
                    .foregroundColor(FAppColor.buttonForeground)
                    .cornerRadius(5)
                    Button(action: { item.onClick(ExtraEDIPharma.ClickEvent.SAVE, ExtraEDIPharma.self) }) {
                        Text(FAppLocalString.saveDesc)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                    }
                    .background(item.isSavable ? FAppColor.buttonBackground : FAppColor.disableBackground)
                    .foregroundColor(item.isSavable ? FAppColor.buttonForeground : FAppColor.disableForeground)
                    .cornerRadius(5)
                }.frame(alignment: .center)
            }
        }
    }
    @ViewBuilder
    func pharmaFileUploadItemContainer(_ item: MediaPickerSourceBuffModel) -> some View {
        Group {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(FAppColor.buttonBackground)
                    .frame(width: 30, height: 30)
                    .overlay {
                        FAppImage.close
                            .resizable()
                            .frame(width: 15, height: 15)
                            .onTapGesture { item.onClick(MediaPickerSourceBuffModel.ClickEvent.SELECT, MediaPickerSourceBuffModel.self) }
                    }
                    .offset(x: -5, y: 5)
                    .onTapGesture { item.onClick(MediaPickerSourceBuffModel.ClickEvent.SELECT, MediaPickerSourceBuffModel.self) }
                    .zIndex(10)
                Image(uiImage: item.thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            }
        }
    }
    var responseListContainer: some View {
        Group {
            LazyVStack {
                ForEach(dataContext.item.responseList, id: \.thisPK) { item in
                    responseItemContainer(item)
                }
            }
        }
    }
    @ViewBuilder
    func responseItemContainer(_ item: ExtraEDIResponse) -> some View {
        Group {
            VStack {
                HStack {
                    Text(item.responseDate)
                        .foregroundColor(FAppColor.foreground)
                        .frame(alignment: .leading)
                    Text(item.pharmaName)
                        .foregroundColor(FAppColor.cardParagraph2)
                        .frame(alignment: .leading)
                    Spacer()
                    ZStack {
                        Text(item.ediState.desc.localized)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                    }
                    .background(item.ediState.parseEDIBackColor())
                    .foregroundColor(item.ediState.parseEDIColor())
                    .cornerRadius(5)
                }
                if item.isOpen {
                    Text(item.etc)
                        .lineLimit(3)
                        .truncationMode(.tail)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { item.onClick(ExtraEDIResponse.ClickEvent.OPEN, ExtraEDIResponse.self) }
            .padding(5)
        }
        .background(FAppColor.cardBackground2)
//        .animation(.easeInOut, value: item.isOpen)
        .cornerRadius(5)
    }
    
    func eventWatch() {
        FEventBus.ins.createEventChannel(EDIUploadEvent.self)
            .sink { _ in
                getData()
                DispatchQueue.main.async {
                    dataContext.closeAble = true
                }
            }.store(in: &cancellables)
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
        setPharmaCommand(data)
        setPharmaFileImageCommand(data)
        setPharmaUploadImageCommand(data)
        setResponseCommand(data)
    }
    
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? EDIDetailViewVM.ClickEvent else { return }
        switch eventName {
        case EDIDetailViewVM.ClickEvent.CLOSE: close()
            break
        case EDIDetailViewVM.ClickEvent.HOSPITAL_DETAIL:
            hospitalDetail()
            break
        }
    }
    func setPharmaCommand(_ data: Any?) {
        guard let array = data as? [Any?], array.count > 1,
              let eventName = array[0] as? ExtraEDIPharma.ClickEvent,
              let dataBuff = array[1] as? ExtraEDIPharma else { return }
        switch eventName {
        case ExtraEDIPharma.ClickEvent.OPEN:
            dataBuff.isOpen = !dataBuff.isOpen
            dataContext.objectWillChange.send()
            break
        case ExtraEDIPharma.ClickEvent.ADD:
            if dataBuff.isAddable {
                dataContext.addPharmaFilePK = dataBuff.thisPK
            }
            break
        case ExtraEDIPharma.ClickEvent.SAVE:
            save(dataBuff)
            break
        }
    }
    func setPharmaFileImageCommand(_ data: Any?) {
        guard let array = data as? [Any?], array.count > 1,
              let eventName = array[0] as? EDIUploadPharmaFileModel.ClickEvent,
              let dataBuff = array[1] as? EDIUploadPharmaFileModel else { return }
        switch eventName {
        case EDIUploadPharmaFileModel.ClickEvent.SHORT:
            dataContext.mediaView = dataBuff
            break
        case EDIUploadPharmaFileModel.ClickEvent.LONG:
            dataContext.mediaListView = dataBuff
            break
        }
    }
    func setPharmaUploadImageCommand(_ data: Any?) {
        guard let array = data as? [Any?], array.count > 1,
              let eventName = array[0] as? MediaPickerSourceBuffModel.ClickEvent,
              let dataBuff = array[1] as? MediaPickerSourceBuffModel else { return }
        switch eventName {
        case MediaPickerSourceBuffModel.ClickEvent.SELECT:
            dataContext.delImage(dataBuff.thisPK)
            break
        }
    }
    func setResponseCommand(_ data: Any?) {
        guard let array = data as? [Any?], array.count > 1,
              let eventName = array[0] as? ExtraEDIResponse.ClickEvent,
              let dataBuff = array[1] as? ExtraEDIResponse else { return }
        switch eventName {
        case ExtraEDIResponse.ClickEvent.OPEN:
            dataBuff.isOpen = !dataBuff.isOpen
            dataContext.objectWillChange.send()
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
    func close() {
        if dataContext.closeAble == false { return }
        dismiss()
    }
    func hospitalDetail() {
        if dataContext.item.tempHospitalPK.isEmpty {
            return
        }
        dataContext.hospitalDetailVisible = true
    }
    func save(_ item: ExtraEDIPharma) {
        if item.isSavable == false { return }
        dataContext.loading()
        dataContext.toast(FAppLocalString.ediFileUpload)
        Task {
            await dataContext.startBackgroundService(item)
        }
    }
}
