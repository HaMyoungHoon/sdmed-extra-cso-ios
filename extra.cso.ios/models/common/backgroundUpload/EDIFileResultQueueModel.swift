class EDIFileResultQueueModel: Equatable {
    var uuid: String = ""
    var ediPK: String = ""
    var ediPharmaPK: String = ""
    var currentMedia: EDIUploadPharmaFileModel = EDIUploadPharmaFileModel()
    var itemIndex: Int = -1
    var itemCount: Int = 0
    var medias: [EDIUploadPharmaFileModel] = []
    var mediaIndexList: [Int] = []
    var ediUploadModel: EDIUploadModel = EDIUploadModel()
    
    func readyToSend() -> Bool {
        return itemCount <= 0
    }
    func appendItemPath(_ media: EDIUploadPharmaFileModel, _ itemIndex: Int) {
        medias.append(EDIUploadPharmaFileModel().copy(media))
        mediaIndexList.append(itemIndex)
        itemCount -= 1
        ediUploadModel.pharmaList.first(where: { $0.pharmaPK == media.pharmaPK })?.fileList.append(media)
    }
    func parseEDIUploadModel() -> EDIUploadModel {
        return ediUploadModel
    }
    
    static func == (lhs: EDIFileResultQueueModel, rhs: EDIFileResultQueueModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
