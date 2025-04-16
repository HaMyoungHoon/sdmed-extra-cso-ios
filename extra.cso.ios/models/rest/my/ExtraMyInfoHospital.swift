class ExtraMyInfoHospital: FDataModelClass<ExtraMyInfoHospital.ClickEvent>, Decodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var orgName: String
    @FallbackString var address: String
    @FallbackDataClass var pharmaList: [ExtraMyInfoPharma]
    
    required override init() {
        _thisPK.wrappedValue = ""
        _orgName.wrappedValue = ""
        _address.wrappedValue = ""
        _pharmaList.wrappedValue = []
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, orgName, address, pharmaList
    }
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
