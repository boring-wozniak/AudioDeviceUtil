import CoreAudio
import Foundation

let GlobalScope = kAudioObjectPropertyScopeGlobal
let MasterElement = kAudioObjectPropertyElementMaster
let SystemObjectID = AudioObjectID(kAudioObjectSystemObject)

// When dealing with `AudioObjectProperty`s, `AudioObject` prefix is implicitly assumed
func toPropertyAddress(selector: AudioObjectPropertySelector) -> AudioObjectPropertyAddress {
    AudioObjectPropertyAddress(mSelector: selector, mScope: GlobalScope, mElement: MasterElement)
}

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

    func getRawData() throws -> (data: UnsafeRawPointer, size: UInt32) {
        var size = try getDataSize()

        var addressVar = address // ¯\_(ツ)_/¯
        let data = UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 1)
        let status = AudioObjectGetPropertyData(objectID, &addressVar, 0, nil, &size, data)

        guard status == noErr else {
            throw MyError.Error(status: status)
        }

        return (UnsafeRawPointer(data), size)
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
