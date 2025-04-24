class EDIAzureQueueModel {
    var uuid: String = ""
    var ediPK: String = ""
    var ediPharmaPK: String = ""
    var media: MediaPickerSourceModel = MediaPickerSourceModel()
    var ediPharmaFileUploadModel: EDIUploadPharmaFileModel = EDIUploadPharmaFileModel()
    var mediaIndex: Int = 0
    
    func parse(_ pharma: EDIUploadPharmaModel, _ blobName: [(String, String)], _ blobInfo: BlobStorageInfoModel) -> EDIAzureQueueModel? {
        let blobMediaName = blobName.first(where: { $0.1 == blobInfo.blobName })?.0
        guard let media = pharma.uploadItems.first(where: { $0.mediaName == blobMediaName }) else {
            return nil
        }
        self.media = media
        ediPharmaFileUploadModel = EDIUploadPharmaFileModel()
        ediPharmaFileUploadModel.pharmaPK = pharma.pharmaPK
        ediPharmaFileUploadModel.blobUrl = "\(blobInfo.blobUrl)/\(blobInfo.blobContainerName)/\(blobInfo.blobName)"
        ediPharmaFileUploadModel.sasKey = blobInfo.sasKey
        ediPharmaFileUploadModel.blobName = blobInfo.blobName
        ediPharmaFileUploadModel.originalFilename = media.mediaName
        ediPharmaFileUploadModel.mimeType = media.mediaMimeType
        ediPharmaFileUploadModel.regDate = FExtensions.ins.getToday().toString("yyyy-MM-dd")
        return self
    }
}
