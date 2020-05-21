import CoreAudio
import Foundation

let DefaultScope = kAudioObjectPropertyScopeGlobal
let DefaultElement = kAudioObjectPropertyElementMaster
let SystemObjectID = AudioObjectID(kAudioObjectSystemObject)

struct PropertyAddress {
    static let everyObjectID = toPropertyAddress(selector: kAudioHardwarePropertyDevices)
    static let deviceUID = toPropertyAddress(selector: kAudioDevicePropertyDeviceUID)
    static let deviceName = toPropertyAddress(selector: kAudioDevicePropertyDeviceName)
}

// TODO: Make it generic
struct Property {

    static func everyObjectID(of id: AudioObjectID) -> Property {
        Property(objectID: id, address: PropertyAddress.everyObjectID)
    }

    static func deviceUID(of id: AudioObjectID) -> Property {
        Property(objectID: id, address: PropertyAddress.deviceUID)
    }

    static func deviceName(of id: AudioObjectID) -> Property {
        Property(objectID: id, address: PropertyAddress.deviceName)
    }

    let objectID: AudioObjectID
    let address: AudioObjectPropertyAddress

    func getDataSize() throws -> UInt32 {
        var size: UInt32 = 0

        var addressVar = address // ¯\_(ツ)_/¯
        let status = AudioObjectGetPropertyDataSize(objectID, &addressVar, 0, nil, &size)
        guard status == noErr else {
            throw MyError.Error(status: status)
        }

        return size
    }

    func getRawData() throws -> (data: UnsafeMutableRawPointer, size: UInt32) {
        var size = try getDataSize()

        var addressVar = address // ¯\_(ツ)_/¯
        let data = UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 1)
        let status = AudioObjectGetPropertyData(objectID, &addressVar, 0, nil, &size, data)

        guard status == noErr else {
            throw MyError.Error(status: status)
        }

        return (data, size)
    }

    func getDataAsArray<Element>(of: Element.Type) throws -> [Element] {
        let (data, size) = try getRawData()
        return data.asArray(size: size)
    }

    func getDataAsCString() throws -> CString {
        let (data, size) = try getRawData()
        return data.asCString(size: size)
    }

    func getDataAsCFString() throws -> CFString {
        let (data, _) = try getRawData()
        return data.asCFString()
    }

}

struct AudioDevice {

    static func getEveryObjectID() throws -> [AudioObjectID] {
        let property = Property.everyObjectID(of: SystemObjectID)
        return try property.getDataAsArray(of: AudioObjectID.self)
    }

    static var all: [AudioDevice]? {
        if let ids = try? getEveryObjectID() {
            return ids.map({ AudioDevice(objectID: $0) })
        }

        return nil
    }

    let objectID: AudioObjectID

    var uid: String? {
        let property = Property.deviceUID(of: objectID)

        if let data = try? property.getDataAsCFString() {
            return String(data as NSString)
        }

        return nil
    }

    var name: String? {
        let property = Property.deviceName(of: objectID)

        if let data = try? property.getDataAsCString() {
            return String(cString: data)
        }

        return nil
    }

}

// When dealing with `AudioObjectProperty`s, `AudioObject` prefix is implicitly assumed
func toPropertyAddress(selector: AudioObjectPropertySelector) -> AudioObjectPropertyAddress {
    AudioObjectPropertyAddress(mSelector: selector, mScope: DefaultScope, mElement: DefaultElement)
}

enum MyError: Error {
    case Error(status: OSStatus)
}

typealias CString = UnsafeMutablePointer<CChar>

extension UnsafeMutableRawPointer {

    func asArray<T>(size: UInt32) -> [T] {
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
