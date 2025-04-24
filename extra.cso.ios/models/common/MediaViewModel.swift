class MediaViewModel: FDataModelClass<MediaViewModel.ClickEvent> {
    var blobUrl: String = ""
    var originalFilename: String = ""
    var mimeType: String = ""
    
    func parse(_ data: EDIUploadPharmaFileModel) -> MediaViewModel {
        self.blobUrl = data.blobUrl
        self.originalFilename = data.originalFilename
        self.mimeType = data.mimeType
        return self
    }
    func parse(_ data: QnAFileModel) -> MediaViewModel {
        self.blobUrl = data.blobUrl
        self.originalFilename = data.originalFilename
        self.mimeType = data.mimeType
        return self
    }
    func parse(_ data: QnAReplyFileModel) -> MediaViewModel {
        self.blobUrl = data.blobUrl
        self.originalFilename = data.originalFilename
        self.mimeType = data.mimeType
        return self
    }
    func parse(_ data: UserTrainingModel) -> MediaViewModel {
        self.blobUrl = data.blobUrl
        self.originalFilename = data.originalFilename
        self.mimeType = data.mimeType
        return self
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
