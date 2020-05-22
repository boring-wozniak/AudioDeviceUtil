import AudioDeviceUtil
import Foundation

func main(arguments: [String] = CommandLine.arguments) {
    if arguments.isEmpty {
        exit(2)
    } else if arguments.count == 1 {
        AudioDevice.all?.forEach({
            if let uid = $0.uid, let name = $0.name {
                print(uid, name)
            }
        })
    } else if arguments.count >= 2 {
        do {
            if let deviceUID = try AudioDevice.findBy(name: arguments[1])?.uid {
                print(deviceUID)
            } else {
                exit(1)
            }
        } catch {
            exit(2)
        }
    }
}
main()
