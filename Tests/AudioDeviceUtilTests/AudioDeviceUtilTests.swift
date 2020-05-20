import CoreAudio
import XCTest
@testable import AudioDeviceUtil

final class AudioDeviceUtilTests: XCTestCase {
    func testToPropertyAddress() {
        let selector = AudioObjectPropertySelector(kAudioObjectSystemObject)
        let result = toPropertyAddress(selector: selector)

        XCTAssertEqual(result.mSelector, selector)
        XCTAssertEqual(result.mScope, DefaultScope)
        XCTAssertEqual(result.mElement, DefaultElement)
    }

    static var allTests = [
        ("testToPropertyAddress", testToPropertyAddress),
    ]
}
