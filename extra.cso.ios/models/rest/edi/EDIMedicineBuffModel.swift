class EDIMedicineBuffModel: Decodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var code: String
    @FallbackString var pharma: String
    @FallbackString var name: String
    @FallbackString var pharmaPK: String
    @FallbackString var hosPK: String
    
    required init() {
        _thisPK.wrappedValue = ""
        _code.wrappedValue = ""
        _pharma.wrappedValue = ""
        _name.wrappedValue = ""
        _pharmaPK.wrappedValue = ""
        _hosPK.wrappedValue = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, code, pharma, name, pharmaPK, hosPK
    }
}
