import XCTest
@testable import AudioDeviceUtil

class UnsafeRawPointerTests: XCTestCase {

    func assertEqualAndNotSame<T: Equatable>(_ expected: T, _ actual: T) {
        XCTAssertEqual(expected, actual)
        XCTAssertTrue(expected as AnyObject !== actual as AnyObject)
    }

    func assertSame<T: Equatable>(_ expected: T, _ actual: T) {
        XCTAssertTrue(expected as AnyObject === actual as AnyObject)
    }

    func testAsArray() throws {
        let expected = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

        let size = expected.count * MemoryLayout<Int>.size
        let pointer = UnsafeRawPointer(expected)
        let actual = pointer.asArray(of: Int.self, size: UInt32(size))

        assertEqualAndNotSame(expected, actual)
    }

    func testAsCString() throws {
        let expected = "This exact string should be returned"
            .cString(using: String.Encoding.ascii)!

        let pointer = UnsafeRawPointer(expected)
        let actual = pointer.asCString(size: UInt32(expected.count))

        assertEqualAndNotSame(expected, actual)
    }

    func testAsCFString() throws {
        var expected = "This exact string should be returned" as CFString

        let pointer = UnsafeRawPointer(&expected)
        let actual = pointer.asCFString()

        XCTAssertEqual(expected, actual)

        // TODO: Think about this behaviour again
        assertSame(expected, actual)
    }

}
