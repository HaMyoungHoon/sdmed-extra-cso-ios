class EDIUploadModel: Codable {
    @FallbackString var thisPK: String
    @FallbackString var userPK: String
    @FallbackString var year: String
    @FallbackString var month: String
    @FallbackString var day: String
    @FallbackString var hospitalPK: String
    @FallbackString var orgName: String
    @FallbackString var tempHospitalPK: String
    @FallbackString var tempOrgName: String
    @FallbackString var name: String
    @FallbackEnum var ediState: EDIState
    @FallbackEnum var ediType: EDIType
    @FallbackString var regDate: String
    @FallbackString var etc: String
    @FallbackDataClass var pharmaList: [EDIUploadPharmaModel]
    @FallbackDataClass var responseList: [EDIUploadResponseModel]
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_userPK.wrappedValue, forKey: CodingKeys.userPK)
        try container.encodeIfPresent(_year.wrappedValue, forKey: CodingKeys.year)
        try container.encodeIfPresent(_month.wrappedValue, forKey: CodingKeys.month)
        try container.encodeIfPresent(_day.wrappedValue, forKey: CodingKeys.day)
        try container.encodeIfPresent(_hospitalPK.wrappedValue, forKey: CodingKeys.hospitalPK)
        try container.encodeIfPresent(_orgName.wrappedValue, forKey: CodingKeys.orgName)
        try container.encodeIfPresent(_tempHospitalPK.wrappedValue, forKey: CodingKeys.tempHospitalPK)
        try container.encodeIfPresent(_tempOrgName.wrappedValue, forKey: CodingKeys.tempOrgName)
        try container.encodeIfPresent(_name.wrappedValue, forKey: CodingKeys.name)
        try container.encodeIfPresent(_ediState.wrappedValue, forKey: CodingKeys.ediState)
        try container.encodeIfPresent(_ediType.wrappedValue, forKey: CodingKeys.ediType)
        try container.encodeIfPresent(_regDate.wrappedValue, forKey: CodingKeys.regDate)
        try container.encodeIfPresent(_etc.wrappedValue, forKey: CodingKeys.etc)
        try container.encodeIfPresent(_pharmaList.wrappedValue, forKey: CodingKeys.pharmaList)
        try container.encodeIfPresent(_responseList.wrappedValue, forKey: CodingKeys.responseList)
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, userPK, year, month, day, hospitalPK, orgName, tempHospitalPK, tempOrgName, name, ediState, ediType, regDate, etc, pharmaList, responseList
    }
}
