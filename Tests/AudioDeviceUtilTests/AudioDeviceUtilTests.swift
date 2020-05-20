import CoreAudio
import XCTest
@testable import AudioDeviceUtil

final class AudioDeviceUtilTests: XCTestCase {
    func testToPropertyAddress() {
        let selector = kAudioHardwarePropertyDevices
        let result = toPropertyAddress(selector: selector)

        XCTAssertEqual(result.mSelector, selector)
        XCTAssertEqual(result.mScope, DefaultScope)
        XCTAssertEqual(result.mElement, DefaultElement)
    }
    
    func testGetObjectIDOfEveryDevice() {
        let result = getObjectIDOfEveryDevice()

        XCTAssertNotNil(result.ids)
        XCTAssertNotEqual(result.ids!.count, 0)
        XCTAssertEqual(result.status, noErr)
    }
    
//    func testGetPropertyDataSize() {
//        let result = getPropertyDataSize(
//            objectID: kAudioObjectSystemObject,
//            selector: kAudioHardwarePropertyDevices
//        )
//
//        XCTAssertEqual(result.status, noErr)
//        XCTAssertNotNil(result.size)
//    }

    static var allTests = [
        ("testToPropertyAddress", testToPropertyAddress),
//        ("testGetPropertyDataSize", testGetPropertyDataSize),
    ]
}