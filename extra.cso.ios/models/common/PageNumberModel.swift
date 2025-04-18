import Foundation

class PageNumberModel: FDataModelClass<PageNumberModel.ClickEvent>, ObservableObject {
    @Published var isSelect: Bool = false
    @Published var pageNumber: Int = 0
    
    init(_ pageNumber: Int) {
        self.pageNumber = pageNumber
    }
    
    func selectThis() -> PageNumberModel {
        isSelect = true
        return self
    }
    func unSelectThis() -> PageNumberModel {
        isSelect = false
        return self
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
