import Foundation
import SwiftUI
import ImageIO
import MobileCoreServices
import Accelerate

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
    
    static func urlToFile(_ fileUrl: URL, _ fileName: String) -> URL {
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

        inputImage = fixImageOrientation(inputImage)

        let fileManager = FileManager.default
        let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootDir = docsDir.appendingPathComponent("SharedFiles", isDirectory: true)

        if !fileManager.fileExists(atPath: rootDir.path) {
            try? fileManager.createDirectory(at: rootDir, withIntermediateDirectories: true)
        }

        let fileExtFinal = fileExt == "webp" ? "webp" : "webp"
        let outputURL = rootDir.appendingPathComponent("\(fileName).\(fileExtFinal)")

        if !fileManager.fileExists(atPath: outputURL.path) {
            if let resizedImage = resizeImage(inputImage, inputImage.size),
               let webpData = resizedImage.webpData() {
                try? webpData.write(to: outputURL)
            } else {
                try? inputData.write(to: outputURL)
            }
        }

        return outputURL
    }
    static func urlToFile(_ fileUrl: String, _ fileName: String) -> URL {
        let fileURL = URL(fileURLWithPath: fileUrl)
        return urlToFile(fileURL, fileName)
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

    static func resizeImage(_ image: UIImage, _ targetSize: CGSize) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        var format = vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            colorSpace: Unmanaged.passUnretained(CGColorSpaceCreateDeviceRGB()),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
            version: 0,
            decode: nil,
            renderingIntent: .defaultIntent
        )
        var sourceBuffer = vImage_Buffer()
        defer { free(sourceBuffer.data) }

        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }

        let scale = UIScreen.main.scale
        let destWidth = Int(targetSize.width * scale)
        let destHeight = Int(targetSize.height * scale)
        let bytesPerPixel = 4
        let destBytesPerRow = destWidth * bytesPerPixel

        guard let destData = malloc(destHeight * destBytesPerRow) else { return nil }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)

        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, vImage_Flags(kvImageHighQualityResampling))
        guard error == kvImageNoError else {
            free(destBuffer.data)
            return nil
        }
        guard let resizedCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, vImage_Flags(kvImageNoAllocate), &error)?.takeRetainedValue(),
              error == kvImageNoError else {
            free(destBuffer.data)
            return nil
        }

        return UIImage(cgImage: resizedCGImage, scale: scale, orientation: image.imageOrientation)
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
