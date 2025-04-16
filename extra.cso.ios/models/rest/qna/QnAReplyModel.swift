import Foundation

class QnAReplyModel: FDataModelClass<QnAReplyModel.ClickEvent>, Codable {
    @FallbackString var thisPK: String
    @FallbackString var headerPK: String
    @FallbackString var userPK: String
    @FallbackString var name: String
    @FallbackString var content: String
    @FallbackDate var regDate: Date
    @FallbackDataClass var fileList: [QnAReplyFileModel]
    
    @Published var open = false
    var htmlContentString: NSAttributedString? {
        return content.htmlToAttributedString
    }
    @Published var currentPosition = 1
    var regDateString: String {
        return FDateTime().setThis(regDate.timeIntervalSince1970).toString("yyyy-MM-dd")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_headerPK.wrappedValue, forKey: CodingKeys.headerPK)
        try container.encodeIfPresent(_userPK.wrappedValue, forKey: CodingKeys.userPK)
        try container.encodeIfPresent(_name.wrappedValue, forKey: CodingKeys.name)
        try container.encodeIfPresent(_content.wrappedValue, forKey: CodingKeys.content)
        try container.encodeIfPresent(_regDate.wrappedValue, forKey: CodingKeys.regDate)
        try container.encodeIfPresent(_fileList.wrappedValue, forKey: CodingKeys.fileList)
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, headerPK, userPK, name, content, regDate, fileList
    }
    
    enum ClickEvent: Int, CaseIterable  {
        case OPEN = 0
    }
}
