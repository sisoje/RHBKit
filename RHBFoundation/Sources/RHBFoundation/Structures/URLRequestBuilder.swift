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

    func acceptJson() {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }

    func basicAuthorization(_ username: String, _ password: String) {
        let base64LoginString = [username, password].joined(separator: ":").data(using: .utf8)!.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    }

    func bearer(_ token: String) {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
