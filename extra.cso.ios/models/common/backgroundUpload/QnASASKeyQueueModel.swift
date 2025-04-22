import Foundation

class QnASASKeyQueueModel {
    var qnaPK: String = ""
    var medias: [MediaPickerSourceModel] = []
    var title: String = ""
    var content: String = ""
    
    func blobName() -> [(String, String)] {
        var ret: [(String, String)] = []
        let id = FAmhohwa.getUserID()
        medias.forEach { media in
            if media.mediaMimeType.isEmpty {
                media.mediaMimeType = FContentsType.getExtMimeTypeString(media.mediaName)
            }
            let ext = FContentsType.getExtMimeType(media.mediaName)
            if ext == "application/octet-stream" {
                ret.append((media.mediaName, "qna/\(id)/\(FExtensions.ins.getToday().toString("yyyyMMdd"))/\(UUID().uuidString).\(media.mediaName)"))
            } else {
                ret.append((media.mediaName, "qna/\(id)/\(FExtensions.ins.getToday().toString("yyyyMMdd"))/\(UUID().uuidString).\(ext)"))
            }
        }
        
        return ret
    }
}
