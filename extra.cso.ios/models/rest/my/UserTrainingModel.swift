import Foundation

class UserTrainingModel: FDataModelClass<UserTrainingModel.ClickEvent>, Decodable, PDefaultInitializable {
    @FallbackString var thisPK: String
    @FallbackString var userPK: String
    @FallbackString var blobUrl: String
    @FallbackString var originalFilename: String
    @FallbackString var mimeType: String
    @FallbackDate var trainingDate: Date
    @FallbackDate var regDate: Date
    
    required override init() {
        _thisPK.wrappedValue = ""
        _userPK.wrappedValue = ""
        _blobUrl.wrappedValue = ""
        _originalFilename.wrappedValue = ""
        _mimeType.wrappedValue = ""
        _trainingDate.wrappedValue = Date()
        _regDate.wrappedValue = Date()
    }
    
    var trainingDateString: String {
        return FDateTime().setThis(trainingDate.timeIntervalSince1970).toString("yyyy-MM-dd")
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, userPK, blobUrl, originalFilename, mimeType, trainingDate, regDate
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
