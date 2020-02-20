import Foundation

public final class URLRequestBuilder {
    private(set) var request: URLRequest

    init(_ url: URL) {
        self.request = URLRequest(url: url)
    }
}

public extension URLRequestBuilder {
    func appendPathComponent(_ path: String) {
        request.url!.appendPathComponent(path)
    }

    func appendQueryItem(name: String, value: String) {
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
        components.queryItems = (components.queryItems ?? []) + [URLQueryItem(name: name, value: value)]
        request.url = components.url!
    }

    func GET() {
        request.httpMethod = "GET"
    }

    func POST() {
        request.httpMethod = "POST"
    }

    func PUT() {
        request.httpMethod = "PUT"
    }

    func PATCH() {
        request.httpMethod = "PATCH"
    }

    func DELETE() {
        request.httpMethod = "DELETE"
    }

    func jsonBody<T: Encodable>(_ encodable: T, _ encoder: JSONEncoder = JSONEncoder()) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(encodable)
    }

    func urlEncodedBody(_ items: [URLQueryItem], _ encoding: String.Encoding = .utf8) {
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = RHBFoundationUtilities.urlEncodeQueryItems(items).data(using: encoding)
    }

    func acceptJson() {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }

    func userAgent(_ agent: String) {
        request.setValue(agent, forHTTPHeaderField: "User-Agent")
    }

    func acceptEncodingGzipDeflate() {
        request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
    }

    func basicAuthorization(_ username: String, _ password: String) {
        let base64LoginString = [username, password].joined(separator: ":").data(using: .utf8)!.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    }

    func bearerAuthorization(_ token: String) {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    func cachePolicy(_ policy: URLRequest.CachePolicy) {
        request.cachePolicy = policy
    }
}
