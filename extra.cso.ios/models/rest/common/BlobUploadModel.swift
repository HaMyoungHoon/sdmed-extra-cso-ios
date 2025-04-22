struct BlobUploadModel: Codable {
    @FallbackString var thisPK: String
    @FallbackString var blobUrl: String
    @FallbackString var sasKey: String
    @FallbackString var blobName: String
    @FallbackString var uploaderPK: String
    @FallbackString var originalFilename: String
    @FallbackString var mimeType: String
    @FallbackString var regDate: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_thisPK.wrappedValue, forKey: CodingKeys.thisPK)
        try container.encodeIfPresent(_blobUrl.wrappedValue, forKey: CodingKeys.blobUrl)
        try container.encodeIfPresent(_sasKey.wrappedValue, forKey: CodingKeys.sasKey)
        try container.encodeIfPresent(_blobName.wrappedValue, forKey: CodingKeys.blobName)
        try container.encodeIfPresent(_uploaderPK.wrappedValue, forKey: CodingKeys.uploaderPK)
        try container.encodeIfPresent(_originalFilename.wrappedValue, forKey: CodingKeys.originalFilename)
        try container.encodeIfPresent(_mimeType.wrappedValue, forKey: CodingKeys.mimeType)
        try container.encodeIfPresent(_regDate.wrappedValue, forKey: CodingKeys.regDate)
    }
    
    func copy(_ rhs: BlobUploadModel) -> BlobUploadModel {
        self.thisPK = rhs.thisPK
        self.blobUrl = rhs.blobUrl
        self.sasKey = rhs.sasKey
        self.blobName = rhs.blobName
        self.uploaderPK = rhs.uploaderPK
        self.originalFilename = rhs.originalFilename
        self.mimeType = rhs.mimeType
        self.regDate = rhs.regDate
        return self
    }
    var blobUrlKey: String {
        return "\(blobUrl)?\(sasKey)"
    }
    
    func apply(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

    enum CodingKeys: String, CodingKey {
        case thisPK, blobUrl, sasKey, blobName, uploaderPK, originalFilename, mimeType, regDate
    }
}
