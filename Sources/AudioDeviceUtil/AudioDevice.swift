import CoreAudio
import Foundation

public struct AudioDevice {

    static func getEveryObjectID() throws -> [AudioObjectID] {
        let property = Property.everyObjectID(of: SystemObjectID)
        return try property.getDataAsArray(of: AudioObjectID.self)
    }

    public static var all: [AudioDevice]? {
        if let ids = try? getEveryObjectID() {
            return ids.map({ AudioDevice(objectID: $0) })
        }

        return nil
    }

    public static func findBy(name: String) throws -> AudioDevice? {
        all?.first(where: { $0.name == name })
    }

    public let objectID: AudioObjectID

    public var uid: String? {
        let property = Property.deviceUID(of: objectID)

        if let data = try? property.getDataAsCFString() {
            return String(data as NSString)
        }

        return nil
    }

    public var name: String? {
        let property = Property.deviceName(of: objectID)

        if let data = try? property.getDataAsCString() {
            return String(cString: data)
        }

        return nil
    }

}
