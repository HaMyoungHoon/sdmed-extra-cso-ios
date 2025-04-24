import Combine
import SwiftUI

struct PriceView: FBaseView {
    @StateObject var dataContext: PriceViewVM
    @State var cancellables =  Set<AnyCancellable>()
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: PriceViewVM(appState))
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                searchContainer.padding(.top, 5)
                itemListContainer.frame(maxHeight: .infinity)
                paginatorContainer.padding(.bottom, 5)
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            dataContext.addEventListener(self)
            getList()
            observeSearch()
        }
    }
    var searchContainer: some View {
        Group {
            HStack {
                TextField("search_desc", text: $dataContext.searchBuff)
                    .textFieldStyle(.roundedBorder)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(FAppColor.border, lineWidth: 1))
            }
        }
    }
    var itemListContainer: some View {
        Group {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(dataContext.medicineModel, id: \.thisPK) { item in
                        VStack {
                            HStack {
                                Text(item.orgName)
                                    .foregroundColor(FAppColor.foreground)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            HStack {
                                Text("client_name")
                                    .foregroundColor(FAppColor.foreground)
                                    .frame(alignment: .leading)
                                Spacer()
                                Text(item.clientName)
                                    .foregroundColor(FAppColor.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.kdCode)
                                    .foregroundColor(FAppColor.foreground)
                                    .frame(alignment: .trailing)
                            }
                            HStack {
                                Text("maker_name")
                                    .foregroundColor(FAppColor.foreground)
                                    .frame(alignment: .leading)
                                Spacer()
                                Text(item.makerName)
                                    .foregroundColor(FAppColor.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.maxPrice.toString)
                                    .foregroundColor(FAppColor.foreground)
                                Text("price_unit")
                                    .foregroundColor(FAppColor.foreground)
                            }
                            HStack {
                                Text(item.etc1)
                                    .foregroundColor(FAppColor.foreground)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.standardWithUnit)
                                    .foregroundColor(FAppColor.foreground)
                                    .frame(alignment: .trailing)
                            }
                        }
                    }
                }
                .padding()
            }
        }.overlay {
            if dataContext.searchLoading {
                ProgressView()
                    .tint(FAppColor.accent)
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
                    .zIndex(100)
            }
        }
    }
    var paginatorContainer: some View {
        Group {
            let model = dataContext.paginationModel
            HStack {
                FAppImage.doubleLeft
                    .tint(model.first ? FAppColor.disableForeground : FAppColor.accent)
                    .onTapGesture {model.onClick(PaginationModel.ClickEvent.FIRST, PaginationModel.self) }
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        LazyHStack {
                            ForEach(model.pages, id: \.pageNumber) { item in
                                pageItem(item)
                            }
                        }.onChange(of: dataContext.page, initial: true) { oldCount, newValue in
                            proxy.scrollTo(newValue + 1)
                        }
                    }
                }.frame(width: UIScreen.main.bounds.size.width - 250, alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
                FAppImage.doubleRight
                    .tint(model.last ? FAppColor.disableForeground : FAppColor.accent)
                    .onTapGesture { model.onClick(PaginationModel.ClickEvent.LAST, PaginationModel.self) }
            }
        }
    }
    @ViewBuilder
    func pageItem(_ item: PageNumberModel) -> some View {
        Group {
            Circle()
                .fill(item.isSelect ? FAppColor.buttonBackground : FAppColor.transparent)
                .frame(width: 30, height: 30)
                .overlay {
                    Text(item.pageNumber.toString)
                        .foregroundColor(item.isSelect ? FAppColor.buttonForeground : FAppColor.foreground)
                }
                .onTapGesture {
                    item.onClick(PageNumberModel.ClickEvent.THIS, PageNumberModel.self)
                }
        }
    }
    func observeSearch() {
        dataContext.$searchBuff
            .receive(on: DispatchQueue.main)
            .sink { newValue in
                if newValue == dataContext.searchString {
                    return
                }
                dataContext.searchLoading = true
            }
            .store(in: &cancellables)
        dataContext.$searchBuff
            .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { newValue in
                if newValue != dataContext.searchString {
                    dataContext.searchString = newValue
                    getList()
                }
                dataContext.searchLoading = false
            }
            .store(in: &cancellables)
    }
    
    func onEvent(_ data: Any?) async {
        setPaginatorComamnd(data)
        setPageNumberCommand(data)
    }
    func setPaginatorComamnd(_ data: Any?) {
        guard let array = data as? [Any], array.count > 1,
              let eventName = array[0] as? PaginationModel.ClickEvent,
              let dataBuff = array[1] as? PaginationModel else {
            return
        }

        switch eventName {
        case PaginationModel.ClickEvent.FIRST:
            if dataBuff.first {
                return
            }
            dataContext.page = 0
            addList()
            break
        case PaginationModel.ClickEvent.PREV:
            break
        case PaginationModel.ClickEvent.NEXT:
            break
        case PaginationModel.ClickEvent.LAST:
            if dataBuff.last {
                return
            }
            dataContext.page = dataBuff.totalPages - 1
            addList()
            break
        }
    }
    func setPageNumberCommand(_ data: Any?) {
        guard let array = data as? [Any], array.count > 1,
              let eventName = array[0] as? PageNumberModel.ClickEvent,
              let dataBuff = array[1] as? PageNumberModel else {
            return
        }

        switch eventName {
        case PageNumberModel.ClickEvent.THIS:
            if dataContext.page == dataBuff.pageNumber - 1 {
                return
            }
            dataContext.page = dataBuff.pageNumber - 1
            addList()
            break
        }
    }
    
    func getList() {
        dataContext.loading()
        Task {
            let ret: RestResultT<RestPage<[ExtraMedicinePriceResponse]>>
            if dataContext.searchString.isEmpty {
                ret = await dataContext.getList()
            } else {
                ret = await dataContext.getLike()
            }
            dataContext.loading(false)
            if ret.result != true {
                dataContext.toast(ret.msg)
            }
            selectPageItem()
        }
    }
    func addList() {
        dataContext.loading()
        Task {
            let ret: RestResultT<RestPage<[ExtraMedicinePriceResponse]>>
            if dataContext.searchString.isEmpty {
                ret = await dataContext.addList()
            } else {
                ret = await dataContext.addLike()
            }
            dataContext.loading(false)
            if ret.result != true {
                dataContext.toast(ret.msg)
            }
            selectPageItem()
        }
    }
    
    func selectPageItem() {
        let model = dataContext.paginationModel
        _ = model.pages.first(where: { $0.isSelect })?.unSelectThis()
        _ = model.pages.first(where: { $0.pageNumber == dataContext.page + 1})?.selectThis()
        model.first = dataContext.page == 0
        model.last = dataContext.page == model.totalPages
    }
}
