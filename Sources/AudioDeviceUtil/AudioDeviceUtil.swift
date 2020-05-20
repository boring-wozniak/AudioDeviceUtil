import CoreAudio

let DefaultScope = kAudioObjectPropertyScopeGlobal
let DefaultElement = kAudioObjectPropertyElementMaster
let SystemObjectID = AudioObjectID(kAudioObjectSystemObject)

// When dealing with `AudioObjectProperty`s, `AudioObject` prefix is implicitly assumed
func toPropertyAddress(selector: AudioObjectPropertySelector) -> AudioObjectPropertyAddress {
    AudioObjectPropertyAddress(mSelector: selector, mScope: DefaultScope, mElement: DefaultElement)
}

// TODO: Maybe it will be better to return UInt32 instead
func getPropertyDataSize(objectID: AudioObjectID, address: inout AudioObjectPropertyAddress) -> (size: UInt32?, status: OSStatus) {
    var result: UInt32 = 0

    let status = AudioObjectGetPropertyDataSize(objectID, &address, 0, nil, &result)

    return (status == noErr ? result : nil, status)
}

func getObjectIDOfEveryDevice() -> (ids: [AudioObjectID]?, status: OSStatus) {
    var address = toPropertyAddress(selector: kAudioHardwarePropertyDevices)

    let dataSizeResult = getPropertyDataSize(objectID: SystemObjectID, address: &address)
    if var dataSize = dataSizeResult.size {
        let numberOfDevices = Int(dataSize) / MemoryLayout<AudioObjectID>.size
        var objectIDs = Array.init(repeating: AudioObjectID(), count: numberOfDevices)

        let dataStatus = AudioObjectGetPropertyData(SystemObjectID, &address, 0, nil, &dataSize, &objectIDs)
        
        return (dataStatus == noErr ? objectIDs : nil, dataStatus)
    }

    return (nil, dataSizeResult.status)
}
