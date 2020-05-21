import XCTest
@testable import AudioDeviceUtil

class UnsafeRawPointerTests: XCTestCase {

    func testAsArray() throws {
        let expected = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

        let size = expected.count * MemoryLayout<Int>.size
        let pointer = UnsafeRawPointer(expected)
        let actual = pointer.asArray(of: Int.self, size: UInt32(size))

        XCTAssertEqual(expected, actual)
    }

    func testAsCString() throws {
        let expected = "This exact string should be returned"
            .cString(using: String.Encoding.ascii)!

        let pointer = UnsafeRawPointer(expected)
        let actual = pointer.asCString(size: UInt32(expected.count))

        XCTAssertEqual(expected, actual)
    }

    func testAsCFString() throws {
        var expected = "This exact string should be returned" as CFString

        let pointer = UnsafeRawPointer(&expected)
        let actual = pointer.asCFString()

        XCTAssertEqual(expected, actual)
    }

}
