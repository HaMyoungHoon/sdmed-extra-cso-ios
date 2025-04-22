import Foundation

class UserTrainingFileSASKeyQueueModel {
    var media: MediaPickerSourceModel = MediaPickerSourceModel()
    var trainingDate: String = ""
    
    func blobName() -> (String, String) {
        let id = FAmhohwa.getUserID()
        if media.mediaMimeType.isEmpty {
            media.mediaMimeType = FContentsType.getExtMimeTypeString(media.mediaName)
        }
        let ext = FContentsType.getExtMimeType(media.mediaMimeType)
        if ext == "application/octet-stream" {
            return (media.mediaName, "user/\(id)/\(FExtensions.ins.getToday().toString("yyyyMMdd"))/\(UUID().uuidString).\(media.mediaName)")
        } else {
            return (media.mediaName, "user/\(id)/\(FExtensions.ins.getToday().toString("yyyyMMdd"))/\(UUID().uuidString).\(ext)")
        }
    }
}
