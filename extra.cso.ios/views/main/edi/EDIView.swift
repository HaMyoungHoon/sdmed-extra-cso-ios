import SwiftUI
import Combine

struct EDIView: FBaseView {
    @StateObject var dataContext: EDIViewVM
    @State var cancellables = Set<AnyCancellable>()
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: EDIViewVM(appState))
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                topContainer.padding(.top, 5)
                itemListContainer.padding(.bottom, 5)
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            dataContext.startDate = FExtensions.ins.getToday().addMonth(-1).toDate()
            dataContext.endDate = Date()
            dataContext.addEventListener(self)
            getList()
            eventWatch()
            checkStoragePK()
        }.fullScreenCover(isPresented: Binding<Bool>(
            get: { dataContext.selectedItem != nil },
            set: { _ in dataContext.selectedItem = nil }
        )) {
            if let selectedItem = dataContext.selectedItem {
                EDIDetailView(dataContext.appState, selectedItem)
            }
        }
    }
    var topContainer: some View {
        Group {
            HStack(spacing: 0) {
                let locale = FExtensions.ins.getLocalize().toLocale()
                DatePicker("", selection: $dataContext.startDate, displayedComponents: .date)
                    .environment(\.locale, locale)
                    .datePickerStyle(.compact)
                    .background(FAppColor.buttonBackground)
                    .foregroundColor(FAppColor.buttonForeground)
                    .cornerRadius(5)
                    .padding(3)
                    .frame(maxWidth: .infinity)
                    .labelsHidden()
                DatePicker("", selection: $dataContext.endDate, displayedComponents: .date)
                    .environment(\.locale, locale)
                    .datePickerStyle(.compact)
                    .background(FAppColor.buttonBackground)
                    .foregroundColor(FAppColor.buttonForeground)
                    .cornerRadius(5)
                    .padding(3)
                    .frame(maxWidth: .infinity)
                    .labelsHidden()
                Button(action: { dataContext.relayCommand.execute(EDIViewVM.ClickEvent.SEARCH) }) {
                    Text("search_desc")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                }
                .background(FAppColor.buttonBackground)
                .foregroundColor(FAppColor.buttonForeground)
                .cornerRadius(5)
                .padding(3)
            }
        }
    }
    var itemListContainer: some View {
        Group {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack {
                        ForEach(dataContext.items, id: \.thisPK) { item in
                            itemContainer(item)
                        }
                    }
                }
            }
        }
    }
    @ViewBuilder
    func itemContainer(_ item: ExtraEDIListResponse) -> some View {
        Group {
            HStack {
                Text(item.getRegDateString)
                    .foregroundColor(FAppColor.foreground)
                HStack {
                    Text(item.orgName)
                        .foregroundColor(item.isDefault ? FAppColor.foreground : FAppColor.accent)
                        .frame(alignment: .leading)
                    if !item.isDefault {
                        Text(item.tempOrgString)
                            .foregroundColor(FAppColor.foreground)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                ZStack {
                    Text(item.ediState.desc.localized)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                }
                .background(item.ediBackColor)
                .foregroundColor(item.ediColor)
                .cornerRadius(5)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                item.onClick(ExtraEDIListResponse.ClickEvent.OPEN, ExtraEDIListResponse.self)
            }
            .background(dataContext.selectedItem == item.thisPK ? FAppColor.buttonBackground : FAppColor.transparent)
        }
    }
    
    func eventWatch() {
        FEventBus.ins.createEventChannel(EDIUploadEvent.self)
            .sink { _ in
                getList()
            }.store(in: &cancellables)
    }
    func checkStoragePK() {
        let ediPK = FStorage.getNotifyPK()
        if !ediPK.isEmpty {
            openEDIItem(ediPK)
        }
        FStorage.removeNotifyPK()
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
        setItemCommand(data)
    }
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? EDIViewVM.ClickEvent else { return }
        switch eventName {
        case EDIViewVM.ClickEvent.START_DATE:
            startCalendarOpen()
            break
        case EDIViewVM.ClickEvent.END_DATE:
            endCalendarOpen()
            break
        case EDIViewVM.ClickEvent.SEARCH:
            getList()
            break
        }
    }
    func setItemCommand(_ data: Any?) {
        guard let array = data as? [Any], array.count > 1,
              let eventName = array[0] as? ExtraEDIListResponse.ClickEvent,
              let dataBuff = array[1] as? ExtraEDIListResponse else { return }
        switch eventName {
        case ExtraEDIListResponse.ClickEvent.OPEN:
            openEDIItem(dataBuff)
            break
        }
    }
    
    func startCalendarOpen() {
        dataContext.startDateSelect = true
    }
    func endCalendarOpen() {
        dataContext.endDateSelect = true
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
    
    func openEDIItem(_ thisPK: String) {
        dataContext.selectedItem = thisPK
    }
    func openEDIItem(_ data: ExtraEDIListResponse) {
        dataContext.selectedItem = data.thisPK
    }
}
