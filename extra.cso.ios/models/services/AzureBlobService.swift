import Foundation
class AzureBlobService: PAzureBlobRepository {
    func upload(_ sasUrl: String, _ fileUrl: URL, _ mimeType: String) async -> RestResult {
        guard let url = URL(string: sasUrl) else {
            return RestResult.setFail("upload fail : \(sasUrl) is not a valid url")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        guard let fileData = try? Data(contentsOf: fileUrl) else {
            return RestResult.setFail("upload fail : \(fileUrl) is not a valid file")
        }
        request.httpBody = fileData
        request.setValue("BlockBlob", forHTTPHeaderField: "x-ms-blob-type")
//        request.setValue(String(fileData.count), forHTTPHeaderField: "Content-Length")
        guard let (_, response) = try? await URLSession.shared.data(for: request) else {
            return RestResult.setFail("upload fail no response")
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return RestResult.setFail("upload fail \(response)")
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            return RestResult.setFail(httpResponse.statusCode, "\(httpResponse)")
        }
        return RestResult.emptyResult()
    }
    func upload(_ sasUrl: String, _ fileData: Data, _ mimeType: String) async -> RestResult {
        guard let url = URL(string: sasUrl) else {
            return RestResult.setFail("upload fail : \(sasUrl) is not a valid url")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        request.httpBody = fileData
        request.setValue("BlockBlob", forHTTPHeaderField: "x-ms-blob-type")
//        request.setValue(String(fileData.count), forHTTPHeaderField: "Content-Length")
        guard let (_, response) = try? await URLSession.shared.data(for: request) else {
            return RestResult.setFail("upload fail no response")
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return RestResult.setFail("upload fail \(response)")
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            return RestResult.setFail(httpResponse.statusCode, "\(httpResponse)")
        }
        return RestResult.emptyResult()
    }
}
