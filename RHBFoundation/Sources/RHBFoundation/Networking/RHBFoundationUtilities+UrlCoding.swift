import Foundation

public extension RHBFoundationUtilities {
    static func urlEncodeString(_ text: String) -> String {
        text
            .components(separatedBy: " ")
            .compactMap { $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) }
            .joined(separator: "+")
    }

    static func urlDecodeString(_ text: String) -> String {
        text
            .components(separatedBy: "+")
            .compactMap { $0.removingPercentEncoding }
            .joined(separator: " ")
    }

    static func urlDecodeQueryString(_ text: String) -> [URLQueryItem] {
        text
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .filter { $0.count == 2 }
            .map { URLQueryItem(name: urlDecodeString($0[0]), value: urlDecodeString($0[1])) }
    }

    static func urlEncodeQueryItems(_ items: [URLQueryItem]) -> String {
        items
            .map { [urlEncodeString($0.name), $0.value.map { urlEncodeString($0) } ?? ""].joined(separator: "=") }
            .joined(separator: "&")
    }
}
