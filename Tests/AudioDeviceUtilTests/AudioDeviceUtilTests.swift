import CoreAudio
import XCTest
@testable import AudioDeviceUtil

final class AudioDeviceUtilTests: XCTestCase {
    func testToPropertyAddress() throws {
        print(try AudioDevice.findBy(name: "Soundflower (2ch)")?.uid)
    }
    
    func testGetObjectIDOfEveryDevice() throws {
        
    }
    
    func testGetDeviceUID() throws {
        let t: AudioDeviceUtilTests.Type = type(of: self)
        print(Mirror(reflecting: type(of: self)).children)
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
