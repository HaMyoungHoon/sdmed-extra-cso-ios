class ExtraMyInfoPharma: FDataModelClass<ExtraMyInfoPharma.ClickEvent>, Decodable, PDefaultInitializable {
    var thisPK: String = ""
    var orgName: String = ""
    var address: String = ""
    
    required override init() {
        thisPK = ""
        orgName = ""
        address = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, orgName, address
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
