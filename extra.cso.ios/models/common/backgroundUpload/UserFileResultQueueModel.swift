class UserFileResultQueueModel: Equatable {
    var uuid: String = ""
    var currentMedia: BlobUploadModel = BlobUploadModel()
    var itemIndex: Int = -1
    var itemCount: Int = 0
    var medias: [BlobUploadModel] = []
    var mediaIndexList: [Int] = []
    var mediaTypeIndex: Int = 0
    
    func readyToSend() -> Bool {
        return itemCount <= 0
    }
    func appendItemPath(_ media: BlobUploadModel, _ itemIndex: Int) {
        medias.append(BlobUploadModel().copy(media))
        mediaIndexList.append(itemIndex)
        itemCount -= 1
    }
    func parseBlobUploadModel() -> BlobUploadModel {
        return medias.first ?? BlobUploadModel()
    }
    func userFileType() -> UserFileType {
        UserFileType.parseIndex(mediaTypeIndex)
    }
    
    static func == (lhs: UserFileResultQueueModel, rhs: UserFileResultQueueModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
