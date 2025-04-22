import Foundation

class EDISASKeyQueueModel {
    var pharmaPK: String = ""
    var ediUploadModel: EDIUploadModel = EDIUploadModel()
    
    func blobName(_ pharmaModel: EDIUploadPharmaModel) -> [(String, String)] {
        var ret: [(String, String)] = []
        let id = FAmhohwa.getUserID()
        pharmaModel.uploadItems.forEach { media in
            if media.mediaMimeType.isEmpty {
                media.mediaMimeType = FContentsType.getExtMimeTypeString(media.mediaName)
            }
            let ext = FContentsType.getExtMimeType(media.mediaName)
            if ext == "application/octet-stream" {
                ret.append((media.mediaName, "edi/\(id)/\(FExtensions.ins.getToday().toString("yyyyMMdd"))/\(UUID().uuidString).\(media.mediaName)"))
            } else {
                ret.append((media.mediaName, "edi/\(id)/\(FExtensions.ins.getToday().toString("yyyyMMdd"))/\(UUID().uuidString).\(ext)"))
            }
        }
        
        return ret
    }
}
