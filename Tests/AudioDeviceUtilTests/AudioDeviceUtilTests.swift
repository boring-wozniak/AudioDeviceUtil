import XCTest
@testable import AudioDeviceUtil

final class AudioDeviceUtilTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AudioDeviceUtil().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
