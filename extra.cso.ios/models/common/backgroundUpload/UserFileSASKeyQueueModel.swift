import Foundation

class UserFileSASKeyQueueModel {
    var medias: [MediaPickerSourceModel] = []
    var mediaTypeIndex: Int = -1
    
    func blobName() -> [(String, String)] {
        var ret: [(String, String)] = []
        let id = FAmhohwa.getUserID()
        medias.forEach { media in
            if media.mediaMimeType.isEmpty {
                media.mediaMimeType = FContentsType.getExtMimeTypeString(media.mediaName)
            }
            let ext = FContentsType.getExtMimeType(media.mediaName)
            if ext == "application/octet-stream" {
                ret.append((media.mediaName, "user/\(id)/\(FExtensions.ins.getToday().toString("yyyyMMdd"))/\(UUID().uuidString).\(media.mediaName)"))
            } else {
                ret.append((media.mediaName, "user/\(id)/\(FExtensions.ins.getToday().toString("yyyyMMdd"))/\(UUID().uuidString).\(ext)"))
            }
        }
        
        return ret
    }
}
