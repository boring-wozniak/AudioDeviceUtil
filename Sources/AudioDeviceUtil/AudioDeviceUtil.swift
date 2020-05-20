import CoreAudio

let DefaultScope = kAudioObjectPropertyScopeGlobal
let DefaultElement = kAudioObjectPropertyElementMaster

// When dealing with `AudioObjectProperty`s, `AudioObject` prefix is implicitly assumed
func toPropertyAddress(selector: AudioObjectPropertySelector) -> AudioObjectPropertyAddress {
    AudioObjectPropertyAddress(mSelector: selector, mScope: DefaultScope, mElement: DefaultElement)
}

func getPropertyDataSize(objectID: AudioObjectID, address: AudioObjectPropertyAddress) -> (size: Int?, status: OSStatus) {
    var result: UInt32 = 0

    var addressVar = address // MUST be `var` so it can be passed as an `in-out` parameter
    let status = AudioObjectGetPropertyDataSize(objectID, &addressVar, 0, nil, &result)

    return (status == noErr ? Int(result) : nil, status)
}

// Convenience method for calls like `getPropertyDataSize(objectID: kAudioObjectSystemObject, selector: kAudioHardwarePropertyDevices)`
func getPropertyDataSize(objectID: Int32, selector: AudioObjectPropertySelector) -> (size: Int?, status: OSStatus) {
    getPropertyDataSize(objectID: AudioObjectID(objectID), address: toPropertyAddress(selector: selector))
}
