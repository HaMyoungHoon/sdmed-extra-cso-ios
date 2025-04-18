import Foundation

class PaginationModel: FDataModelClass<PaginationModel.ClickEvent>, ObservableObject {
    @Published var pages: [PageNumberModel] = []
    @Published var first: Bool = false
    @Published var last: Bool = false
    var empty: Bool = false
    var size: Int = 0
    var number: Int = 0
    var numberOfElements: Int = 0
    var totalElements: Int = 0
    var totalPages: Int = 0
    
    func initThis<T: PRestPage>(_ data: T?) -> PaginationModel {
        guard let data = data else {
            return self
        }
        
        first = data.first
        last = data.last
        empty = data.empty
        size = data.size
        number = data.number
        numberOfElements = data.numberOfElements
        totalElements = data.totalElements
        totalPages = data.totalPages
        var buff: [PageNumberModel] = []
        for i in 0..<totalPages {
            buff.append(PageNumberModel(i  + 1))
        }
        pages = buff
        return self
    }
    
    enum ClickEvent: Int, CaseIterable {
        case FIRST = 0
        case PREV = 1
        case NEXT = 2
        case LAST = 3
    }
}
