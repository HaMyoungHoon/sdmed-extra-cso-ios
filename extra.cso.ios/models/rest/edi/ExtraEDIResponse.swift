import Foundation

class ExtraEDIResponse: FDataModelClass<ExtraEDIResponse.ClickEvent>, Decodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var ediPK: String
    @FallbackString var pharmaPK: String
    @FallbackString var pharmaName: String
    @FallbackString var etc: String
    @FallbackEnum var ediState: EDIState
    @FallbackDate var regDate: Date
    
    @Published var isOpen = false
    var responseDate: String {
        return FDateTime().setThis(regDate).toString("yyyy-MM")
    }
    
    required override init() {
        _thisPK.wrappedValue = ""
        _ediPK.wrappedValue = ""
        _pharmaPK.wrappedValue = ""
        _pharmaName.wrappedValue = ""
        _etc.wrappedValue = ""
        _ediState.wrappedValue = EDIState.None
        _regDate.wrappedValue = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, ediPK, pharmaPK, pharmaName, etc, ediState, regDate
    }
    
    enum ClickEvent: Int, CaseIterable {
        case OPEN = 0
    }
}
