import CoreAudio
import XCTest
@testable import AudioDeviceUtil

class PropertyTests: XCTestCase {

    func testToPropertyAddress() throws {
        let selector = kAudioHardwarePropertyDevices
        let address = toPropertyAddress(selector: selector)

        XCTAssertEqual(address.mSelector, selector)
        XCTAssertEqual(address.mScope, GlobalScope)
        XCTAssertEqual(address.mElement, MasterElement)
    }

}
