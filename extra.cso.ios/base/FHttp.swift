import Foundation

class FHttp {
    var queryParams: [URLQueryItem] = []
    var headers: [String: String] = [:]
    
    func addParam(_ key: String, _ value: String) {
        queryParams.append(URLQueryItem(name: key, value: value))
    }
    func setHeader(_ key: String, _ value: String) {
        headers[key] = value
    }
    func clear() {
        queryParams.removeAll()
        headers.removeAll()
    }
    
    func get(_ url: String) async -> RestResult {
        guard let request = getRequest(url, "GET") else {
            return RestResult.setFail("invalid url")
        }
        return await FExtensions.ins.restTry {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResult.self, from: data)
            return decoded
        }
    }
    func post(_ url: String) async -> RestResult {
        guard let request = getRequest(url, "POST") else {
            return RestResult.setFail( "invalid url")
        }
        return await FExtensions.ins.restTry {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResult.self, from: data)
            return decoded
        }
    }
    func post<B: Encodable>(_ url: String, _ body: B) async -> RestResult {
        guard var request = getRequest(url, "POST") else {
            return RestResult.setFail( "invalid url")
        }
        return await FExtensions.ins.restTry {
            request.httpBody = try JSONEncoder().encode(body)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResult.self, from: data)
            return decoded
        }
    }
    func put(_ url: String) async -> RestResult {
        guard let request = getRequest(url, "PUT") else {
            return RestResult.setFail( "invalid url")
        }
        return await FExtensions.ins.restTry {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResult.self, from: data)
            return decoded
        }
    }
    func put<B: Encodable>(_ url: String, _ body: B) async -> RestResult {
        guard var request = getRequest(url, "PUT") else {
            return RestResult.setFail( "invalid url")
        }
        return await FExtensions.ins.restTry {
            request.httpBody = try JSONEncoder().encode(body)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResult.self, from: data)
            return decoded
        }
    }
    func blob(_ url: String) async -> RestResultT<Data> {
        guard let request = getRequest(url, "GET") else {
            return RestResultT<Data>.setFail("invalid url")
        }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return RestResultT<Data>.setSuccess(data)
        } catch {
            return RestResultT<Data>.setFail(error.localizedDescription)
        }
    }
    func delete(_ url: String) async -> RestResult {
        guard let request = getRequest(url, "DELETE") else {
            return RestResult.setFail("invalid url")
        }
        return await FExtensions.ins.restTry {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResult.self, from: data)
            return decoded
        }
    }
    func get<T: Decodable>(_ url: String, _ responseType: T.Type) async -> RestResultT<T> {
        guard let request = getRequest(url, "GET") else {
            return RestResultT<T>.setFail("invalid url")
        }
        return await FExtensions.ins.restTry<T> {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResultT<T>.self, from: data)
            return decoded
        }
    }
    func post<T: Decodable>(_ url: String, _ responseType: T.Type) async -> RestResultT<T> {
        guard let request = getRequest(url, "POST") else {
            return RestResultT<T>.setFail( "invalid url")
        }
        return await FExtensions.ins.restTry<T> {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResultT<T>.self, from: data)
            return decoded
        }
    }
    func post<T: Decodable, B: Encodable>(_ url: String, _ body: B, _ responseType: T.Type) async -> RestResultT<T> {
        guard var request = getRequest(url, "POST") else {
            return RestResultT<T>.setFail( "invalid url")
        }
        return await FExtensions.ins.restTry<T> {
            request.httpBody = try JSONEncoder().encode(body)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResultT<T>.self, from: data)
            return decoded
        }
    }
    func put<T: Decodable>(_ url: String, _ responseType: T.Type) async -> RestResultT<T> {
        guard let request = getRequest(url, "PUT") else {
            return RestResultT<T>.setFail( "invalid url")
        }
        return await FExtensions.ins.restTry<T> {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResultT<T>.self, from: data)
            return decoded
        }
    }
    func put<T: Decodable, B: Encodable>(_ url: String, _ body: B, _ responseType: T.Type) async -> RestResultT<T> {
        guard var request = getRequest(url, "PUT") else {
            return RestResultT<T>.setFail( "invalid url")
        }
        return await FExtensions.ins.restTry<T> {
            request.httpBody = try JSONEncoder().encode(body)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResultT<T>.self, from: data)
            return decoded
        }
    }
    func delete<T: Decodable>(_ url: String, _ responseType: T.Type) async -> RestResultT<T> {
        guard let request = getRequest(url, "DELETE") else {
            return RestResultT<T>.setFail("invalid url")
        }
        return await FExtensions.ins.restTry<T> {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(RestResultT<T>.self, from: data)
            return decoded
        }
    }
    
    private func getRequest(_ url: String, _ method: String = "GET") -> URLRequest? {
        guard let urlBuff = gatheringURL(url) else {
            return nil
        }
        var request = URLRequest(url: urlBuff)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = FRestVariable.ins.token {
            request.setValue(token, forHTTPHeaderField: FConstants.AUTH_TOKEN)
        }
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        self.clear()
        return request
    }
    private func gatheringURL(_ url: String) -> URL? {
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        urlComponents.queryItems = queryParams
        guard let urlBuff = urlComponents.url else {
            return nil
        }
        return urlBuff
    }
}
