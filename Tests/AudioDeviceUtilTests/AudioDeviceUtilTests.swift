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
    
    func testGetObjectIDOfEveryDevice() throws {
        let result = try getObjectIDOfEveryDevice()
        print(result)
        XCTAssertTrue(result.count > 0)
    }
    
    func testGetDeviceUID() throws {
        let result = try getDeviceUID(objectID: 79)
        print("Device UID is '\(result)'")
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
