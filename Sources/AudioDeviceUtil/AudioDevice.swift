import CoreAudio
import Foundation

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
