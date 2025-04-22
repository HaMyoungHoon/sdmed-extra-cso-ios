class QnAResultQueueModel {
    var uuid: String = ""
    var qnaPK: String = ""
    var currentMedia: QnAFileModel = QnAFileModel()
    var itemIndex: Int = -1
    var itemCount: Int = 0
    var medias: [QnAFileModel] = []
    var mediaIndexList: [Int] = []
    var title: String = ""
    var content: String = ""
    
    func readyToSend() -> Bool {
        return itemCount <= 0
    }
    func appendItemPath(_ media: QnAFileModel, _ itemIndex: Int) {
        medias.append(QnAFileModel().copy(media))
        mediaIndexList.append(itemIndex)
        itemCount -= 1
    }
    func parsePostData() -> QnAContentModel {
        let ret = QnAContentModel()
        ret.content = self.content
        ret.fileList.append(contentsOf: self.medias)
        return ret
    }
    func parsePostReply() -> QnAReplyModel {
        let ret = QnAReplyModel()
        ret.content = content
        ret.fileList = addFile(medias)
        return ret
    }
    func addFile(_ items: [QnAFileModel]) -> [QnAReplyFileModel] {
        var ret: [QnAReplyFileModel] = []
        items.forEach { item in
            ret.append(QnAReplyFileModel().apply {
                $0.blobUrl = item.blobUrl
                $0.originalFilename = item.originalFilename
                $0.mimeType = item.mimeType
                $0.regDate = item.regDate
            })
        }
        return ret
    }
}
