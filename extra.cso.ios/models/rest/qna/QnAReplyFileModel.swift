class QnAReplyFileModel: FDataModelClass<QnAReplyFileModel.ClickEvent>, Decodable, Encodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var replyPK: String
    @FallbackString var blobUrl: String
    @FallbackString var originalFilename: String
    @FallbackString var mimeType: String
    @FallbackString var regDate: String
    
    required override init() {
        _thisPK.wrappedValue = ""
        _replyPK.wrappedValue = ""
        _blobUrl.wrappedValue = ""
        _originalFilename.wrappedValue = ""
        _mimeType.wrappedValue = ""
        _regDate.wrappedValue = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_replyPK.wrappedValue, forKey: CodingKeys.replyPK)
        try container.encodeIfPresent(_blobUrl.wrappedValue, forKey: CodingKeys.blobUrl)
        try container.encodeIfPresent(_originalFilename.wrappedValue, forKey: CodingKeys.originalFilename)
        try container.encodeIfPresent(_mimeType.wrappedValue, forKey: CodingKeys.mimeType)
        try container.encodeIfPresent(_regDate.wrappedValue, forKey: CodingKeys.regDate)
    }
    enum CodingKeys: String, CodingKey {
        case thisPK, replyPK, blobUrl, originalFilename, mimeType, regDate
    }
    enum ClickEvent: Int, CaseIterable {
        case Long = 0
        case SHORT = 1
    }
}
