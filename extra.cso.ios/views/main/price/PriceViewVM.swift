import Foundation
class PriceViewVM: FBaseViewModel {
    var priceListService = FDI.medicinePriceListSerivce
    @Published var searchLoading = false
    @Published var searchBuff = ""
    var searchString = ""
    @Published var previousPage = 0
    @Published var page = 0
    @Published var size = 20
    @Published var medicineModel: [ExtraMedicinePriceResponse] = []
    @Published var paginationModel = PaginationModel()
    
    private func commandSet() {
        medicineModel.forEach { $0.relayCommand = relayCommand }
        paginationModel.relayCommand = relayCommand
        paginationModel.pages.forEach { $0.relayCommand = relayCommand }
    }
    func getList() async -> RestResultT<RestPage<[ExtraMedicinePriceResponse]>> {
        page = 0
        let ret = await priceListService.getList(page, size)
        if ret.result == true {
            medicineModel = ret.data?.content ?? []
            paginationModel = PaginationModel().initThis(ret.data)
            commandSet()
        }
        
        return ret
    }
    func getLike() async -> RestResultT<RestPage<[ExtraMedicinePriceResponse]>> {
        page = 0
        let ret = await priceListService.getLike(searchString, page, size)
        if ret.result == true {
            medicineModel = ret.data?.content ?? []
            paginationModel = PaginationModel().initThis(ret.data)
            commandSet()
        }
        return ret
    }
    func addList() async -> RestResultT<RestPage<[ExtraMedicinePriceResponse]>> {
        let ret = await priceListService.getList(page, size)
        if ret.result == true {
            medicineModel = ret.data?.content ?? []
            commandSet()
        }
        return ret
    }
    func addLike() async -> RestResultT<RestPage<[ExtraMedicinePriceResponse]>> {
        let ret = await priceListService.getLike(searchString, page, size)
        if ret.result == true {
            medicineModel = ret.data?.content ?? []
            commandSet()
        }
        return ret
    }
}
