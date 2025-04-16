class HospitalTempFileModel: Decodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var hospitalTempPK: String
    @FallbackString var blobUrl: String
    @FallbackString var originalFilename: String
    @FallbackString var mimeType: String
    @FallbackEnum var fileType: HospitalTempFileType
    @FallbackString var regDate: String
    
    required init() {
        _thisPK.wrappedValue = ""
        _hospitalTempPK.wrappedValue = ""
        _blobUrl.wrappedValue = ""
        _originalFilename.wrappedValue = ""
        _mimeType.wrappedValue = ""
        _fileType.wrappedValue = HospitalTempFileType.TAXPAYER
        _regDate.wrappedValue = ""
    }
    
    
    enum CodingKeys: String, CodingKey {
        case thisPK, hospitalTempPK, blobUrl, originalFilename, mimeType, fileType, regDate
        
    }
}
