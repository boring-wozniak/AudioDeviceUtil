import Foundation

enum MyError: Error {
    case Error(status: OSStatus)
}

typealias CString = UnsafePointer<CChar>
