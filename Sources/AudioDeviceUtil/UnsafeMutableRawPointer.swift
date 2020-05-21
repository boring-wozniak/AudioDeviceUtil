import Foundation

extension UnsafeMutableRawPointer {

    func asArray<T>(of: T.Type=T.self, size: UInt32) -> [T] {
        let numberOfElements = Int(size) / MemoryLayout<T>.size
        let typedSelf = bindMemory(to: T.self, capacity: numberOfElements)

         // TODO: Check whether there is a nicer way of doing it
        return (0 ..< numberOfElements).map({ typedSelf[$0] })
    }

    func asCString(size: UInt32) -> CString {
        let numberOfCharacters = Int(size) / MemoryLayout<CChar>.size
        return bindMemory(to: CChar.self, capacity: numberOfCharacters)
    }

    func asCFString() -> CFString {
        let typedSelf = bindMemory(to: CFString.self, capacity: 1)
        return typedSelf.pointee
    }

}
