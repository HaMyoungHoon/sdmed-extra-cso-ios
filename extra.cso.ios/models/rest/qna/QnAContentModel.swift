import Foundation

class QnAContentModel: Codable {
    @FallbackString var thisPK: String
    @FallbackString var headerPK: String
    @FallbackString var userPK: String
    @FallbackString var content: String
    @FallbackDataClass var fileList: [QnAFileModel]
    @FallbackDataClass var replyList: [QnAReplyModel]
    
    var htmlContentString: NSAttributedString? {
        return content.htmlToAttributedString
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_headerPK.wrappedValue, forKey: CodingKeys.headerPK)
        try container.encodeIfPresent(_userPK.wrappedValue, forKey: CodingKeys.userPK)
        try container.encodeIfPresent(_content.wrappedValue, forKey: CodingKeys.content)
        try container.encodeIfPresent(_fileList.wrappedValue, forKey: CodingKeys.fileList)
        try container.encodeIfPresent(_replyList.wrappedValue, forKey: CodingKeys.replyList)
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, headerPK, userPK, content, fileList, replyList
    }
}
