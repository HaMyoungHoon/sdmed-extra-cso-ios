import Foundation
import SwiftUI
import ImageIO
import MobileCoreServices
import Accelerate
import libwebp

class FImageUtils {
    static func fileDelete(_ fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
        }
    }
    static func fileDelete(_ filePath: String) {
        let url = URL(fileURLWithPath: filePath)
        fileDelete(url)
    }
    static func isImage(_ ext: String) -> Bool {
        let lower = ext.lowercased()
        if lower == "jpeg" {
            return true
        }
        if lower == "jpg" {
            return true
        }
        if lower == "png" {
            return true
        }
        if lower == "bmp" {
            return true
        }
        if lower == "webp" {
            return true
        }
        if lower == "heic" {
            return true
        }
        if lower == "gif" {
            return true
        }
        
        return false
    }
    static func isGif(_ ext: String) -> Bool {
        return ext.lowercased() == "gif"
    }
    static func isPdf(_ ext: String) -> Bool {
        return ext.lowercased() == "pdf"
    }
    static func isExcel(_ ext: String) -> Bool {
        return ext.lowercased() == "xls" || ext.lowercased() == "xlsx"
    }
    
    static func getDefaultImage(_ mimeType: String?) -> Image {
        let ext = FContentsType.getExtMimeType(mimeType)
        if isPdf(ext) {
            return FAppImage.imagePdf
        } else if isExcel(ext) {
            return FAppImage.imageExcel
        } else if ext == "docx" || ext == "doc" {
            return FAppImage.imageWord
        } else if ext == "zip" {
            return FAppImage.imageZip
        }
        
        return FAppImage.imageNoImage
    }
    
    static func urlToFile(_ fileUrl: URL, _ fileName: String, _ originSize: Int) -> URL {
        let fileExt = fileUrl.pathExtension.lowercased()
        guard isImage(fileExt) else {
            return fileUrl
        }
        if isGif(fileExt) {
            return urlToGifFile(fileUrl, fileName)
        }
        guard let inputData = try? Data(contentsOf: fileUrl),
              var inputImage = UIImage(data: inputData) else {
            return fileUrl
        }

//        inputImage = fixImageOrientation(inputImage)

        let fileManager = FileManager.default
        let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootDir = docsDir.appendingPathComponent("SharedFiles", isDirectory: true)

        if !fileManager.fileExists(atPath: rootDir.path) {
            try? fileManager.createDirectory(at: rootDir, withIntermediateDirectories: true)
        }

        let fileExtFinal = fileExt == "webp" ? "webp" : "webp"
        let outputURL = rootDir.appendingPathComponent("\(fileName).\(fileExtFinal)")

        if !fileManager.fileExists(atPath: outputURL.path) {
            if let resizedImage = resizeImage(inputImage, inputImage.size) {
                if let webpData = encodeToWebP(resizedImage, originSize) {
                    try? webpData.write(to: outputURL)
                } else if let jpegData = dynamicJpeg(resizedImage, originSize) {
                    try? jpegData.write(to: outputURL)
                } else if let pngData = resizedImage.pngData() {
                    try? pngData.write(to: outputURL)
                } else if let heicData = resizedImage.heicData() {
                    try? heicData.write(to: outputURL)
                } else {
                    try? inputData.write(to: outputURL)
                }
            } else {
                try? inputData.write(to: outputURL)
            }
        }

        return outputURL
    }
    static func urlToFile(_ fileUrl: String, _ fileName: String, _ originSize: Int) -> URL {
        let fileURL = URL(fileURLWithPath: fileUrl)
        return urlToFile(fileURL, fileName, originSize)
    }
    static func urlToGifFile(_ fileUrl: URL, _ fileName: String) -> URL {
        let fileManager = FileManager.default
        let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootDir = docsDir.appendingPathComponent("SharedFiles", isDirectory: true)

        if !fileManager.fileExists(atPath: rootDir.path) {
            try? fileManager.createDirectory(at: rootDir, withIntermediateDirectories: true)
        }

        let outputURL = rootDir.appendingPathComponent("\(fileName).gif")
        if !fileManager.fileExists(atPath: outputURL.path) {
            try? fileManager.copyItem(at: fileUrl, to: outputURL)
        }

        return outputURL
    }
    static func urlToGifFile(_ fileUrl: String, _ fileName: String) -> URL {
        let fileURL = URL(fileURLWithPath: fileUrl)
        return urlToGifFile(fileURL, fileName)
    }
    static func encodeToWebP(_ image: UIImage, _ originSize: Int) -> Data? {
        guard let cgImage = image.cgImage else { return nil }
        let width = Int32(cgImage.width)
        let height = Int32(cgImage.height)
        let targetSize = FConstants.MAX_FILE_SIZE > originSize ? originSize : FConstants.MAX_FILE_SIZE
        var quality: Float = 75.0
        guard let dataProvider = cgImage.dataProvider,
              let pixelData = dataProvider.data as Data? else { return nil }
        let bytesPerRow = Int32(cgImage.bytesPerRow)
        while quality > 10.0 {
            var outputData: UnsafeMutablePointer<UInt8>? = nil
            var outputSize: Int = 0
            
            pixelData.withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) in
                if let baseAddress = rawBufferPointer.baseAddress {
                    outputSize = WebPEncodeRGBA(baseAddress.assumingMemoryBound(to: UInt8.self),
                                                width,
                                                height,
                                                bytesPerRow,
                                                quality,
                                                &outputData)
                }
            }
            
            if let outputPointer = outputData, outputSize > 0 {
                let webpData = Data(bytes: outputPointer, count: outputSize)
                free(outputPointer) // 메모리 해제

                if webpData.count <= targetSize {
                    return webpData
                }
            }
            
            quality -= 5.0
        }
        
        return nil
    }
    static func dynamicJpeg(_ image: UIImage, _ originSize: Int) -> Data? {
        var qulity = CGFloat(0.7)
        var ret = image.jpegData(compressionQuality: qulity)
        let targetSize = FConstants.MAX_FILE_SIZE > originSize ? originSize : FConstants.MAX_FILE_SIZE
        while let data = ret, data.count > targetSize, qulity > 0.1 {
            qulity -= 0.1
            ret = image.jpegData(compressionQuality: qulity)
        }
        return ret
    }
    static func resizeImage(_ image: UIImage, _ targetSize:CGSize) -> UIImage? {
        let size = calcResize(targetSize)
        if size.width >= targetSize.width && size.height >= targetSize.height {
            return image
        }
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return resizedImage
    }

    static func fixImageOrientation(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    static func calcResize(_ size: CGSize, _ limitSize: Float = 2500) -> CGSize {
        let limit = CGFloat(limitSize)
        let height = size.height
        let width = size.width
        var inSampleSize = 1.0
        if height > limit || width > limit {
            let heightRatio = height / limit
            let widthRatio = width / limit
            inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio
        }
        return CGSize(width: CGFloat(width * inSampleSize), height: CGFloat(height * inSampleSize))
    }
    
    @ViewBuilder
    static func asyncImage(_ blobUrl: String? = nil, _ blobMimeType: String? = nil) -> some View {
        let mimeType = FContentsType.getExtMimeType(blobMimeType)
        if blobUrl == nil || !FImageUtils.isImage(mimeType) {
            FImageUtils.getDefaultImage(blobMimeType).resizable()
        } else {
            if let url = URL(string: blobUrl!) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case AsyncImagePhase.empty: ProgressView()
                    case AsyncImagePhase.success(let image): image.resizable()
                    case AsyncImagePhase.failure: FAppImage.imageNoImage.resizable()
                    default: FAppImage.imageNoImage.resizable()
                    }
                }
            } else {
                FAppImage.imageNoImage.resizable()
            }
        }
    }
}
