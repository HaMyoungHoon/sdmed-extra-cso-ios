import Foundation

class ExtraEDIPharma: FDataModelClass<ExtraEDIPharma.ClickEvent>, Decodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var ediPK: String
    @FallbackString var pharmaPK: String
    @FallbackString var orgName: String
    @FallbackString var year: String
    @FallbackString var month: String
    @FallbackString var day: String
    @FallbackBool var isCarriedOver: Bool
    @FallbackEnum var ediState: EDIState
    @FallbackDataClass var fileList: [EDIUploadPharmaFileModel]
    
    @Published var uploadItems: [MediaPickerSourceModel] = []
    var isAddable: Bool {
        return ediState.isEditable()
    }
    @Published var isOpen: Bool = false
    var isSavable: Bool {
        return !uploadItems.isEmpty
    }
    @Published var currentPosition: Int = 1
    var yearMonth: String {
        return "\(year)-\(month)"
    }
    
    required override init () {
        _thisPK.wrappedValue = ""
        _ediPK.wrappedValue = ""
        _pharmaPK.wrappedValue = ""
        _orgName.wrappedValue = ""
        _year.wrappedValue = ""
        _month.wrappedValue = ""
        _day.wrappedValue = ""
        _isCarriedOver.wrappedValue = false
        _ediState.wrappedValue = EDIState.None
        _fileList.wrappedValue = []
    }
    func toEDIUploadPharmaModel() -> EDIUploadPharmaModel {
        let ret = EDIUploadPharmaModel()
        ret.thisPK = thisPK
        ret.ediPK = ediPK
        ret.pharmaPK = pharmaPK
        ret.orgName = orgName
        ret.year = year
        ret.month = month
        ret.day = day
        ret.isCarriedOver = isCarriedOver
        ret.ediState = ediState
        ret.uploadItems = uploadItems
        return ret
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, ediPK, pharmaPK, orgName, year, month, day, isCarriedOver, ediState, fileList
    }
    
    enum ClickEvent: Int, CaseIterable {
        case OPEN = 0
        case ADD = 1
        case SAVE = 2
    }
}
