class QnAAzureQueueModel {
    var uuid: String = ""
    var qnaPK: String = ""
    var media: MediaPickerSourceModel = MediaPickerSourceModel()
    var qnaFileModel: QnAFileModel = QnAFileModel()
    var mediaIndex: Int = 0
    
    func parse(_ keyQueue: QnASASKeyQueueModel, _ blobName: [(String, String)], _ blobInfo: BlobStorageInfoModel) -> QnAAzureQueueModel? {
        let blobMediaName = blobName.first(where: { $0.1 == blobInfo.blobName })?.1
        guard let media = keyQueue.medias.first(where: { $0.mediaName == blobMediaName }) else {
            return nil
        }
        self.media = media
        qnaFileModel = QnAFileModel()
        qnaFileModel.blobUrl = "\(blobInfo.blobUrl)/\(blobInfo.blobContainerName)/\(blobInfo.blobName)"
        qnaFileModel.sasKey = blobInfo.sasKey
        qnaFileModel.blobName = blobInfo.blobName
        qnaFileModel.originalFilename = media.mediaName
        qnaFileModel.mimeType = media.mediaMimeType
        qnaFileModel.regDate = FExtensions.ins.getToday().toString()
        return self
    }
}
