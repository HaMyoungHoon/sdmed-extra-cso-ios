class EDIUploadPharmaMedicineModel: Codable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var ediPK: String
    @FallbackString var pharmaPK: String
    @FallbackString var makerCode: String
    @FallbackString var medicinePK: String
    @FallbackString var name: String
    @FallbackInt var count: Int
    @FallbackInt var price: Int
    @FallbackInt var charge: Int
    @FallbackString var year: String
    @FallbackString var month: String
    @FallbackString var day: String
    @FallbackBool var inVisible: Bool
    
    required init() {
        thisPK = ""
        ediPK = ""
        pharmaPK = ""
        makerCode = ""
        medicinePK = ""
        name = ""
        count = 0
        price = 0
        charge = 0
        year = ""
        month = ""
        day = ""
        inVisible = false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_ediPK.wrappedValue, forKey: CodingKeys.ediPK)
        try container.encodeIfPresent(_pharmaPK.wrappedValue, forKey: CodingKeys.pharmaPK)
        try container.encodeIfPresent(_makerCode.wrappedValue, forKey: CodingKeys.makerCode)
        try container.encodeIfPresent(_medicinePK.wrappedValue, forKey: CodingKeys.medicinePK)
        try container.encodeIfPresent(_name.wrappedValue, forKey: CodingKeys.name)
        try container.encodeIfPresent(_count.wrappedValue, forKey: CodingKeys.count)
        try container.encodeIfPresent(_price.wrappedValue, forKey: CodingKeys.price)
        try container.encodeIfPresent(_charge.wrappedValue, forKey: CodingKeys.charge)
        try container.encodeIfPresent(_year.wrappedValue, forKey: CodingKeys.year)
        try container.encodeIfPresent(_month.wrappedValue, forKey: CodingKeys.month)
        try container.encodeIfPresent(_day.wrappedValue, forKey: CodingKeys.day)
        try container.encodeIfPresent(_inVisible.wrappedValue, forKey: CodingKeys.inVisible)
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, ediPK, pharmaPK, makerCode, medicinePK, name, count, price, charge, year, month, day, inVisible
    }
}
