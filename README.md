# AudioDeviceUtil
## Installation
```swift
// In your Package.swift
.package(url: "https://github.com/boring-wozniak/AudioDeviceUtil", from: "0.0.3"),
```
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

// This is exactly what this library is about :)
// See https://stackoverflow.com/q/1983984 for more
sound.playbackDeviceIdentifier = deviceUID

if !sound.play() {
    fatalError("Cannot play the sound")
}

// Wait until the playback finishes
sleep(UInt32(sound.duration))
```
## My grandma would write it better...🤬
Please, [open the issue](https://github.com/boring-wozniak/AudioDeviceUtil/issues/new) and describe briefly what exactly is looking troublesome in the code, ideally, with links, references, etc... This is my first gig on the Swift territory so feedback from more experienced developers is very appreciated
