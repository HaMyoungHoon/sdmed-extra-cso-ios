import Foundation
protocol PAzureBlobRepository {
    func upload(_ sasUrl: String, _ fileUrl: URL, _ mimeType: String) async -> RestResult
    func upload(_ sasUrl: String, _ fileData: Data, _ mimeType: String) async -> RestResult
}
