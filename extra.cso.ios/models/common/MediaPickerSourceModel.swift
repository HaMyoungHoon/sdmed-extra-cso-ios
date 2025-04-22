import Foundation
import Photos

class MediaPickerSourceModel {
    var mediaUrl: URL? = nil
    var mediaName: String = ""
    var mediaFileType: MediaFileType = MediaFileType.UNKNOWN
    var mediaDateTime: String = ""
    var mediaMimeType: String = ""
    var originSize: Int = 0
    
    func apply(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
    func parse(_ data: MediaPickerSourceBuffModel?) async -> MediaPickerSourceModel? {
        guard let data = data else { return nil }
        guard let resource = PHAssetResource.assetResources(for: data.asset).first else {
            return nil
        }
        let filename = UUID().uuidString + "." + resource.originalFilename
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        mediaUrl = outputURL
        mediaName = resource.originalFilename
        mediaMimeType = FContentsType.findContentType(mediaName)
        mediaFileType = MediaFileType.parse(data.asset.mediaType)
        mediaDateTime = FDateTime().setThis(data.asset.creationDate).toString()
        return await withCheckedContinuation { continuation in
            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = false
            PHAssetResourceManager.default().requestData(for: resource, options: options, dataReceivedHandler: { data in
                self.originSize += Int(data.count)
            }, completionHandler: { error in
                if let _ = error {
                    continuation.resume(returning: nil)
                } else {
                    PHAssetResourceManager.default().writeData(for: resource, toFile: outputURL, options: nil) { error in
                        if let _ = error {
                            continuation.resume(returning: nil)
                        } else {
                            continuation.resume(returning: self.mediaUrl == nil ? nil : self)
                        }
                    }
                }
            })
        }
    }
}
