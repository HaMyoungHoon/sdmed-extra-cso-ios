class UserFileAzureQueueModel {
    var uuid: String = ""
    var media: MediaPickerSourceModel = MediaPickerSourceModel()
    var userFileModel: BlobUploadModel = BlobUploadModel()
    var itemIndex: Int = 0
    var mediaTypeIndex: Int = 0
    func parse(_ keyQueue: UserFileSASKeyQueueModel, _ blobName: [(String, String)], _ blobInfo: BlobStorageInfoModel) -> UserFileAzureQueueModel? {
        let blobMediaName = blobName.first(where: { $0.1 == blobInfo.blobName })?.0
        guard let media = keyQueue.medias.first(where: { $0.mediaName == blobMediaName} ) else {
            return nil
        }
        self.media = media
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
