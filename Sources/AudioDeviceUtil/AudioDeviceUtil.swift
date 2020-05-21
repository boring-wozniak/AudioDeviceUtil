import CoreAudio
import Foundation

let DefaultScope = kAudioObjectPropertyScopeGlobal
let DefaultElement = kAudioObjectPropertyElementMaster
let SystemObjectID = AudioObjectID(kAudioObjectSystemObject)

struct AudioDevice {

    static let allObjectIDsPropertyAddress = toPropertyAddress(selector: kAudioHardwarePropertyDevices)
    static let uidPropertyAddress = toPropertyAddress(selector: kAudioDevicePropertyDeviceUID)
    static let namePropertyAddress = toPropertyAddress(selector: kAudioDevicePropertyDeviceName)

    static func getPropertySize(objectID: AudioObjectID, address: inout AudioObjectPropertyAddress) throws -> UInt32 {
        var size: UInt32 = 0

        let status = AudioObjectGetPropertyDataSize(objectID, &address, 0, nil, &size)
        guard status == noErr else {
            throw MyError.Error(status: status)
        }

        return size
    }
    
    static func getProperty(objectID: AudioObjectID, address: inout AudioObjectPropertyAddress) throws -> (data: UnsafeMutableRawPointer, size: UInt32) {
        var size = try getPropertySize(objectID: objectID, address: &address)

        let data = UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 1)
        let status = AudioObjectGetPropertyData(objectID, &address, 0, nil, &size, data)

        guard status == noErr else {
            throw MyError.Error(status: status)
        }

        return (data, size)
    }

    static func getObjectIDOfEveryDevice() throws -> [AudioObjectID] {
        var address = allObjectIDsPropertyAddress
        let (data, size) = try getProperty(objectID: SystemObjectID, address: &address)

        return data.asArray(size: size)
    }
    
    static var all: [AudioDevice]? {
        if let ids = try? getObjectIDOfEveryDevice() {
            return ids.map({ AudioDevice(objectID: $0) })
        }

        return nil
    }

    let objectID: AudioObjectID

    func getPropertySize(address: inout AudioObjectPropertyAddress) throws -> UInt32 {
        try AudioDevice.getPropertySize(objectID: objectID, address: &address)
    }

    func getProperty(address: inout AudioObjectPropertyAddress) throws -> (data: UnsafeMutableRawPointer, size: UInt32) {
        try AudioDevice.getProperty(objectID: objectID, address: &address)
    }

    var uid: String? {
        var address = AudioDevice.uidPropertyAddress

        if let (data, _) = try? getProperty(address: &address) {
            return data.asString()
        }

        return nil
    }

    var name: String? {
        var address = AudioDevice.namePropertyAddress

        if let (data, size) = try? getProperty(address: &address) {
            return data.asString2(size: size)
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

func getPropertyDataSize(objectID: AudioObjectID, address: inout AudioObjectPropertyAddress) throws -> UInt32 {
    var size: UInt32 = 0

    let status = AudioObjectGetPropertyDataSize(objectID, &address, 0, nil, &size)
    guard status == noErr else {
        throw MyError.Error(status: status)
    }

    return size
}

func getRawPropertyData(objectID: AudioObjectID, address: inout AudioObjectPropertyAddress) throws -> (data: UnsafeMutableRawPointer, size: UInt32) {
    var size = try getPropertyDataSize(objectID: objectID, address: &address)

    let data = UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 1)
    let status = AudioObjectGetPropertyData(objectID, &address, 0, nil, &size, data)

    guard status == noErr else {
        throw MyError.Error(status: status)
    }

    return (data, size)
}

func getObjectIDOfEveryDevice() throws -> [AudioObjectID] {
    var address = toPropertyAddress(selector: kAudioHardwarePropertyDevices)
    let (data, size) = try getRawPropertyData(objectID: SystemObjectID, address: &address)

    return data.asArray(size: size)
}

extension UnsafeMutableRawPointer {

    func asArray<T>(size: UInt32) -> [T] {
        let numberOfElements = Int(size) / MemoryLayout<T>.size
        let typedSelf = bindMemory(to: T.self, capacity: numberOfElements)

         // TODO: Check whether there is a nicer way of doing it
        return (0 ..< numberOfElements).map({ typedSelf[$0] })
    }

    func asString() -> String {
        let typedSelf = bindMemory(to: CFString.self, capacity: 1)

         // TODO: Check whether there is a nicer way of doing it
        return String.init(typedSelf.pointee as NSString)
    }

    func asString2(size: UInt32) -> String {
        let numberOfCharacters = Int(size) / MemoryLayout<CChar>.size
        let typedSelf = bindMemory(to: CChar.self, capacity: numberOfCharacters)
        return String.init(cString: typedSelf)
    }

}

func getDeviceUID(objectID: AudioObjectID) throws -> String {
    var address = toPropertyAddress(selector: kAudioDevicePropertyDeviceUID)
    let (data, _) = try getRawPropertyData(objectID: objectID, address: &address)
    return data.asString()
}

func getDeviceName(objectID: AudioObjectID) throws -> String {
    var address = toPropertyAddress(selector: kAudioDevicePropertyDeviceName)
    let (data, size) = try getRawPropertyData(objectID: objectID, address: &address)
    return data.asString2(size: size)
}
