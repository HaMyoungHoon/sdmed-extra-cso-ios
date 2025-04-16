import Foundation

class EDIPharmaBuffModel: FDataModelClass<EDIPharmaBuffModel.ClickEvent>, Decodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var hosPK: String
    @FallbackString var code: String
    @FallbackString var orgName: String
    @FallbackString var innerName: String
    @FallbackDataClass var medicineList: [EDIMedicineBuffModel]
    @Published var uploadItems: [MediaPickerSourceModel] = []
    @Published var isSelect = false
    @Published var isOpen = false
    var uploadItemCount: String {
        return "(\(uploadItems.count))"
    }
    
    required override init() {
        _thisPK.wrappedValue = ""
        _hosPK.wrappedValue = ""
        _code.wrappedValue = ""
        _orgName.wrappedValue = ""
        _innerName.wrappedValue = ""
        _medicineList.wrappedValue = []
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, hosPK, code, orgName, innerName, medicineList
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
        case OPEN = 1
        case ADD = 2
    }
}
