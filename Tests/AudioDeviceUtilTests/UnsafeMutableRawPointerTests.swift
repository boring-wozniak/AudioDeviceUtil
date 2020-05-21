import XCTest
@testable import AudioDeviceUtil

class UnsafeMutableRawPointerTests: XCTestCase {

    func testAsArray() throws {
        let expected = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

        let size = expected.count * MemoryLayout<Int>.size
        let pointer = UnsafeMutableRawPointer(mutating: expected)
        let actual = pointer.asArray(of: Int.self, size: UInt32(size))

        XCTAssertEqual(expected, actual)
    }

}
