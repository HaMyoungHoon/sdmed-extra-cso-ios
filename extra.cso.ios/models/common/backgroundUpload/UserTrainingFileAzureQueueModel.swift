class UserTrainingFileAzureQueueModel {
    var uuid: String = ""
    var media: MediaPickerSourceModel = MediaPickerSourceModel()
    var userFileModel: BlobUploadModel = BlobUploadModel()
    var trainingDate: String = ""
    
    func parse(_ keyQueue: UserTrainingFileSASKeyQueueModel, _ blobInfo: BlobStorageInfoModel) -> UserTrainingFileAzureQueueModel {
        self.media = keyQueue.media
        userFileModel = BlobUploadModel().apply {
            $0.blobUrl = "\(blobInfo.blobUrl)/\(blobInfo.blobContainerName)/\(blobInfo.blobName)"
            $0.sasKey = blobInfo.sasKey
            $0.blobName = blobInfo.blobName
            $0.originalFilename = media.mediaName
            $0.mimeType = media.mediaMimeType
            $0.regDate = FExtensions.ins.getToday().toString("yyyy-MM-dd")
        }
        
        return self
    }
}
