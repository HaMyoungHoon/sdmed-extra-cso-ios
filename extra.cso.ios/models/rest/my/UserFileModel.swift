import Foundation

class UserFileModel: Decodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var userPK: String
    @FallbackString var blobUrl: String
    @FallbackString var originalFilename: String
    @FallbackString var mimeType: String
    @FallbackDate var regDate: Date
    @FallbackEnum var userFileType: UserFileType
    
    required init() {
        thisPK = ""
        userPK = ""
        blobUrl = ""
        originalFilename = ""
        mimeType = ""
        regDate = Date()
        userFileType = UserFileType.Taxpayer
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, userPK, blobUrl, originalFilename, mimeType, regDate, userFileType
    }
}
