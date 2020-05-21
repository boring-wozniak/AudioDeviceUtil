import CoreAudio
import Foundation

let DefaultScope = kAudioObjectPropertyScopeGlobal
let DefaultElement = kAudioObjectPropertyElementMaster
let SystemObjectID = AudioObjectID(kAudioObjectSystemObject)

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

func getPropertyData<T>(objectID: AudioObjectID, address: inout AudioObjectPropertyAddress) throws -> [T] {
    let (rawData, size) = try getRawPropertyData(objectID: objectID, address: &address)
    defer {
        rawData.deallocate()
    }
    let numberOfElements = Int(size) / MemoryLayout<T>.size
    let typedData = rawData.bindMemory(to: T.self, capacity: numberOfElements)
    return (0 ..< numberOfElements).map({ typedData[$0] })
}

func getObjectIDOfEveryDevice() throws -> [AudioObjectID] {
    var address = toPropertyAddress(selector: kAudioHardwarePropertyDevices)
    return try getPropertyData(objectID: SystemObjectID, address: &address)
}

func getDeviceUID(objectID: AudioObjectID) -> (uid: String?, status: OSStatus) {
//    var address = toPropertyAddress(selector: kAudioDevicePropertyDeviceUID)
//    let dataSizeResult = getPropertyDataSize(objectID: objectID, address: &address)
//    if var dataSize = dataSizeResult.size {
//        var dataResult = UnsafeMutablePointer<CFString>.allocate(capacity: Int(dataSize))
//        let dataStatus = AudioObjectGetPropertyData(objectID, &address, 0, nil, &dataSize, &dataResult)
//        return (dataStatus == noErr ? String.init(dataResult.pointee as NSString) : nil, dataStatus)
//    }
//    return (nil, dataSizeResult.status)
    return (nil, noErr)
}
