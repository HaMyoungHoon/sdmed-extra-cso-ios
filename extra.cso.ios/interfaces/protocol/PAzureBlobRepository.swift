import Foundation
protocol PAzureBlobRepository {
    func upload(_ sasUrl: String, _ fileUrl: URL, _ mimeType: String) async -> RestResult
}
