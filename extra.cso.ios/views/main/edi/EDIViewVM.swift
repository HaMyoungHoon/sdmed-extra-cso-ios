import Foundation

class EDIViewVM: FBaseViewModel {
    var ediListService = FDI.ediListService
    @Published var items: [ExtraEDIListResponse] = []
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var startDateSelect = false
    @Published var endDateSelect = false
    @Published var selectedItem: String? = nil
    
    override init(_ appState: FAppState) {
        super.init(appState)
    }
    
    func getList() async -> RestResultT<[ExtraEDIListResponse]> {
        let ret = await ediListService.getList(startDate.toString, endDate.toString)
        if ret.result == true {
            items = ret.data ?? []
            items.forEach { $0.relayCommand = relayCommand }
        }
        return ret
    }
    
    enum ClickEvent: Int, CaseIterable {
        case START_DATE = 0
        case END_DATE = 1
        case SEARCH = 2
    }
}
