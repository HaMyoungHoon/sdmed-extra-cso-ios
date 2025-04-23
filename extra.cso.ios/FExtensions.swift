import Foundation
import ImageIO
import MobileCoreServices
import SwiftUI
import UniformTypeIdentifiers

class FExtensions {
    static let ins = FExtensions()
    
    func restTry<T>(_ fn: @escaping () async throws -> RestResultT<T>) async -> RestResultT<T> {
        do {
            return try await fn()
        } catch {
            return FDataExceptionHandler.handleException<T>(error)
        }
    }
    func restTry(_ fn: @escaping () async throws -> RestResult) async -> RestResult {
        do {
            return try await fn()
        } catch {
            return FDataExceptionHandler.handleException(error)
        }
    }
    
    func getLocalize() -> FLocalize {
        return FLocalize.parseThis(Locale.current.language.languageCode?.identifier ?? "")
    }
    func getToday() -> FDateTime {
        return FDateTime().setLocalize(getLocalize()).setThis(Date().timeIntervalSince1970)
    }
    func getDurationToTime(_ duration: Int) -> String {
        let buff = duration / 100
        if buff < 0 {
            return ""
        }
        if buff == 0 {
            return "0:00"
        }
        let hours = buff / 3600
        let minutes = (buff % 3600) / 60
        let seconds = buff % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

extension Date {
    var toString: String {
        return FDateTime().setThis(self.timeIntervalSince1970).toString("yyyy-MM-dd")
    }
}

extension String {
    subscript (_ index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
    subscript (_ range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let endIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<endIndex]
    }
    subscript (_ startIndex: Int, _ endIndex: Int) -> Substring {
        return self[startIndex..<endIndex]
    }
    mutating func delete(_ start: Int, _ length: Int) {
        guard start >= 0, length > 0, start < self.count else { return }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
        self.removeSubrange(startIndex..<endIndex)
    }
    var toChar: Character {
        return self.first!
    }
    func toChar(_ index: Int) -> Character {
        return self[index]
    }
    var toInt: Int {
        return Int(self)!
    }
    func tryToInt(_ def: Int) -> Int {
        guard let ret = Int(self) else {
            return def
        }
        return ret
    }
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    mutating func replace(_ old: String, _ new: String) -> String {
        return self.replacingOccurrences(of: old, with: new)
    }
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                                          ],
                                          documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension Substring {
    var toString: String {
        return String(self)
    }
    var toInt: Int {
        guard let ret = Int(self.toString) else {
            return 0
        }
        return ret
    }
}

extension Bool {
    var toString: String {
        return String(self)
    }
    var toInt: Int {
        return self ? 1 : 0
    }
}

extension Character {
    var toInt: Int {
        guard let ret = unicodeScalars.first else {
            FException.FFatal.notDefined("illegal character unicodeScalars.first is null")
            return 0
        }
        return Int(ret.value)
    }
    var toString: String {
        return String(self)
    }
}

extension Int {
    var toChar: Character {
        guard let ret = Unicode.Scalar(self) else {
            FException.FFatal.notDefined("illegal int self is not unicode")
            return Character("")
        }
        return Character(ret)
    }
    var toString: String {
        return String(self)
    }
    var toDouble: Double {
        return Double(self)
    }
}

extension Double {
    var toString: String {
        return String(self)
    }
    var toInt: Int {
        return Int(self)
    }
}

extension Array: PDefaultInitializable {
    public init() {
        self = []
    }
}

extension UIImage {
    func webpData(_ compressionQuality: CGFloat = 1.0) -> Data? {
        guard let cgImage = self.cgImage else { return nil }
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, UTType.webP.identifier as CFString, 1, nil) else {
            return nil
        }

        let properties: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: compressionQuality
        ]

        CGImageDestinationAddImage(destination, cgImage, properties as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { return nil }

        return data as Data
    }
}
