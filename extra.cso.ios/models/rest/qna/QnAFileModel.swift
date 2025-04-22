class QnAFileModel: FDataModelClass<QnAFileModel.ClickEvent>, Decodable, Encodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var headerPK: String
    @FallbackString var blobUrl: String
    @FallbackString var sasKey: String
    @FallbackString var blobName: String
    @FallbackString var originalFilename: String
    @FallbackString var mimeType: String
    @FallbackString var regDate: String
    
    var blobUrlKey: String {
        return "\(blobUrl)?\(sasKey)"
    }
    
    required override init() {
        _thisPK.wrappedValue = ""
        _headerPK.wrappedValue = ""
        _blobUrl.wrappedValue = ""
        _sasKey.wrappedValue = ""
        _blobName.wrappedValue = ""
        _originalFilename.wrappedValue = ""
        _mimeType.wrappedValue = ""
        _regDate.wrappedValue = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_headerPK.wrappedValue, forKey: CodingKeys.headerPK)
        try container.encodeIfPresent(_blobUrl.wrappedValue, forKey: CodingKeys.blobUrl)
        try container.encodeIfPresent(_sasKey.wrappedValue, forKey: CodingKeys.sasKey)
        try container.encodeIfPresent(_blobName.wrappedValue, forKey: CodingKeys.blobName)
        try container.encodeIfPresent(_originalFilename.wrappedValue, forKey: CodingKeys.originalFilename)
        try container.encodeIfPresent(_mimeType.wrappedValue, forKey: CodingKeys.mimeType)
        try container.encodeIfPresent(_regDate.wrappedValue, forKey: CodingKeys.regDate)
    }
    
    func copy(_ rhs: QnAFileModel) -> QnAFileModel {
        self.thisPK = rhs.thisPK
        self.headerPK = rhs.headerPK
        self.blobUrl = rhs.blobUrl
        self.sasKey = rhs.sasKey
        self.blobName = rhs.blobName
        self.originalFilename = rhs.originalFilename
        self.mimeType = rhs.mimeType
        self.regDate = rhs.regDate
        return self
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, headerPK, blobUrl, sasKey, blobName, originalFilename, mimeType, regDate
    }
    
    enum ClickEvent: Int, CaseIterable {
        case LONG = 0
        case SHORT = 1
    }
}
