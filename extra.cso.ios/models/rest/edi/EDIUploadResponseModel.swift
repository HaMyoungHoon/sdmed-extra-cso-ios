import Foundation

class EDIUploadResponseModel: Decodable, Encodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var ediPK: String
    @FallbackString var pharmaPK: String
    @FallbackString var pharmaName: String
    @FallbackString var userPK: String
    @FallbackString var userName: String
    @FallbackString var etc: String
    @FallbackEnum var ediState: EDIState
    @FallbackString var regDate: String
    @Published var isOpen = false
    
    required init() {
        thisPK = ""
        ediPK = ""
        pharmaPK = ""
        pharmaName = ""
        userPK = ""
        userName = ""
        etc = ""
        ediState = EDIState.None
        regDate = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_ediPK.wrappedValue, forKey: CodingKeys.ediPK)
        try container.encodeIfPresent(_pharmaPK.wrappedValue, forKey: CodingKeys.pharmaPK)
        try container.encodeIfPresent(_pharmaName.wrappedValue, forKey: CodingKeys.pharmaName)
        try container.encodeIfPresent(_userPK.wrappedValue, forKey: CodingKeys.userPK)
        try container.encodeIfPresent(_userName.wrappedValue, forKey: CodingKeys.userName)
        try container.encodeIfPresent(_etc.wrappedValue, forKey: CodingKeys.etc)
        try container.encodeIfPresent(_ediState.wrappedValue, forKey: CodingKeys.ediState)
        try container.encodeIfPresent(_regDate.wrappedValue, forKey: CodingKeys.regDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, ediPK, pharmaPK, pharmaName, userPK, userName, etc, ediState, regDate
    }
    
    enum ClickEvent: Int, CaseIterable {
        case OPEN = 0
    }
}
