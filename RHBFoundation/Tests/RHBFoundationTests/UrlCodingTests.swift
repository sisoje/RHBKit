import RHBFoundation
import XCTest

final class UrlCodingTests: XCTestCase {
    func testCoding() {
        let wikiparamlist: [URLQueryItem] = [
            URLQueryItem(name: "Name", value: "Gareth Wylie"),
            URLQueryItem(name: "Age", value: "24"),
            URLQueryItem(name: "Formula", value: "a + b == 13%!")
        ]
        let wikiencodedparams = "Name=Gareth+Wylie&Age=24&Formula=a+%2B+b+%3D%3D+13%25%21"
        let encodedQueryString = RHBFoundationUtilities.urlEncodeQueryItems(wikiparamlist)
        XCTAssertEqual(encodedQueryString, wikiencodedparams)
        let decodedQueryItems = RHBFoundationUtilities.urlDecodeQueryString(encodedQueryString)
        XCTAssertEqual(decodedQueryItems, wikiparamlist)
        XCTAssertEqual(RHBFoundationUtilities.urlDecodeQueryString(wikiencodedparams), wikiparamlist)
    }

    func testURLReencoding() {
        let items: [URLQueryItem] = [
            URLQueryItem(name: "++Name", value: "  ja +++ !-_%% Wylie àáââāæãâ  "),
            URLQueryItem(name: "  Age#$%#$%#$%#$%#$%", value: "%$^%$^%$^$%^%^&*&^%^$%#@@%^&**(&^%$#@#$%^&*(&*^%$#@$%^&*"),
            URLQueryItem(name: "%%Formula2", value: ""),
            URLQueryItem(name: "", value: ""),
            URLQueryItem(name: "", value: "ojha"),
            URLQueryItem(name: "same", value: "1"),
            URLQueryItem(name: "same", value: "2")
        ]
        let encodedQueryString = RHBFoundationUtilities.urlEncodeQueryItems(items)
        let decodedQueryItems = RHBFoundationUtilities.urlDecodeQueryString(encodedQueryString)
        XCTAssertEqual(decodedQueryItems, items)
    }
}
