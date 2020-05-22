# AudioDeviceUtil
## Usage Example
```swift
import AppKit
import AudioObjectUtil

let path = "/path/to/the/sound/you/want/to/play"
guard let sound = NSSound(contentsOfFile: path, byReference: true) else {
    fatalError("Failed to create an NSSound object with file path '\(path)'")
}

let deviceName = "As shown in Sound Preferences"
guard let deviceUID = try findDeviceUIDBy(name: deviceName) else {
    fatalError("Cannot find a device with name '\(deviceName)'")
}

sound.playbackDeviceIdentifier = deviceUID
if !sound.play() {
    fatalError("Cannot play the sound")
}

// Wait until the playback finishes
sleep(UInt32(sound.duration))
```
