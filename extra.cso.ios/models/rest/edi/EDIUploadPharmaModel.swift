import Foundation

class EDIUploadPharmaModel: FDataModelClass<EDIUploadPharmaModel.ClickEvent>, Decodable, Encodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var ediPK: String
    @FallbackString var pharmaPK: String
    @FallbackString var orgName: String
    @FallbackString var year: String
    @FallbackString var month: String
    @FallbackString var day: String
    @FallbackBool var isCarriedOver: Bool
    @FallbackEnum var ediState: EDIState
    @FallbackDataClass var medicineList: [EDIUploadPharmaMedicineModel]
    @FallbackDataClass var fileList: [EDIUploadPharmaFileModel]

    @Published var uploadItems: [MediaPickerSourceModel] = []
    var isAddable: Bool {
        return ediState.isEditable()
    }
    @Published var isOpen: Bool = false
    var isSavable: Bool {
        return uploadItems.count > 0
    }
    @Published var currentPosition: Int = 1
    var yearMonth: String {
        return "\(year)-\(month)"
    }
    
    required override init() {
        _thisPK.wrappedValue = ""
        _ediPK.wrappedValue = ""
        _pharmaPK.wrappedValue = ""
        _orgName.wrappedValue = ""
        _year.wrappedValue = ""
        _month.wrappedValue = ""
        _day.wrappedValue = ""
        _isCarriedOver.wrappedValue = false
        _ediState.wrappedValue = EDIState.None
        _medicineList.wrappedValue = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_ediPK.wrappedValue, forKey: CodingKeys.ediPK)
        try container.encodeIfPresent(_pharmaPK.wrappedValue, forKey: CodingKeys.pharmaPK)
        try container.encodeIfPresent(_orgName.wrappedValue, forKey: CodingKeys.orgName)
        try container.encodeIfPresent(_year.wrappedValue, forKey: CodingKeys.year)
        try container.encodeIfPresent(_month.wrappedValue, forKey: CodingKeys.month)
        try container.encodeIfPresent(_day.wrappedValue, forKey: CodingKeys.day)
        try container.encodeIfPresent(_isCarriedOver.wrappedValue, forKey: CodingKeys.isCarriedOver)
        try container.encodeIfPresent(_ediState.wrappedValue, forKey: CodingKeys.ediState)
        try container.encodeIfPresent(_medicineList.wrappedValue, forKey: CodingKeys.medicineList)
        try container.encodeIfPresent(_fileList.wrappedValue, forKey: CodingKeys.fileList)
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, ediPK, pharmaPK, orgName, year, month, day, isCarriedOver, ediState, medicineList, fileList
    }
    
    enum ClickEvent: Int, CaseIterable {
        case OPEN = 0
        case ADD = 1
        case SAVE = 2
    }
}
