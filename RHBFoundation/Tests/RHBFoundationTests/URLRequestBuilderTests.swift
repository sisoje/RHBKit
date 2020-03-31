import RHBFoundation
import XCTest

final class URLRequestBuilderTests: XCTestCase {
    func testUrlBuilder() {
        let url = URL(string: "https://google.com")!
        let builder = URLRequestBuilder(url)
        builder.GET()
        builder.appendPathComponent("test")
        builder.appendQueryItem(name: "q", value: "1")
        let request = builder.request
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://google.com/test?q=1")
    }
}
