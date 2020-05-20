import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AudioDeviceUtilTests.allTests),
    ]
}
#endif
