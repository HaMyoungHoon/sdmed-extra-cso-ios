class EDIUploadPharmaFileModel: FDataModelClass<EDIUploadPharmaFileModel.ClickEvent>, Decodable, Encodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var ediPharmaPK: String
    @FallbackString var pharmaPK: String
    @FallbackString var blobUrl: String
    @FallbackString var originalFilename: String
    @FallbackString var mimeType: String
    @FallbackString var regDate: String
    var sasKey: String = ""
    var blobName: String = ""
    
    required override init() {
        _thisPK.wrappedValue = ""
        _ediPharmaPK.wrappedValue = ""
        _pharmaPK.wrappedValue = ""
        _blobUrl.wrappedValue = ""
        _originalFilename.wrappedValue = ""
        _mimeType.wrappedValue = ""
        _regDate.wrappedValue = ""
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_ediPharmaPK.wrappedValue, forKey: CodingKeys.ediPharmaPK)
        try container.encodeIfPresent(_pharmaPK.wrappedValue, forKey: CodingKeys.pharmaPK)
        try container.encodeIfPresent(_blobUrl.wrappedValue, forKey: CodingKeys.blobUrl)
        try container.encodeIfPresent(_originalFilename.wrappedValue, forKey: CodingKeys.originalFilename)
        try container.encodeIfPresent(_mimeType.wrappedValue, forKey: CodingKeys.mimeType)
        try container.encodeIfPresent(_regDate.wrappedValue, forKey: CodingKeys.regDate)
    }
    
    func copy(_ rhs: EDIUploadPharmaFileModel) -> EDIUploadPharmaFileModel {
        self.thisPK = rhs.thisPK
        self.ediPharmaPK = rhs.ediPharmaPK
        self.pharmaPK = rhs.pharmaPK
        self.blobUrl = rhs.blobUrl
        self.sasKey = rhs.sasKey
        self.blobName = rhs.blobName
        self.originalFilename = rhs.originalFilename
        self.mimeType = rhs.mimeType
        self.regDate = rhs.regDate
        return self
    }
    var blobUrlKey: String {
        return "\(blobUrl)?\(sasKey)"
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, ediPharmaPK, pharmaPK, blobUrl, originalFilename, mimeType, regDate
    }
    
    enum ClickEvent: Int, CaseIterable {
        case LONG = 0
        case SHORT = 1
    }
}
