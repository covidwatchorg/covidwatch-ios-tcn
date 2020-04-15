//
//  Created by Zsombor Szabo on 04/07/2018.
//

import Foundation

extension UserDefaults {

    public static let shared: UserDefaults = .standard

    public struct Key {
        public static let isUserSick = "isUserSick"
        public static let didUserMakeContactWithSickUser = "didUserMakeContactWithSickUser"
        public static let isContactEventLoggingEnabled = "isContactEventLoggingEnabled"
        public static let lastContactEventsDownloadDate = "lastContactEventsDownloadDate"
        public static let isFirstTimeUser = "isFirstTimeUser"
        public static let lastTestedDate = "lastTestedDate"

        public static let registration: [String: Any] = [
            isUserSick: false,
            isContactEventLoggingEnabled: false,
            isFirstTimeUser: true
        ]
    }

    @objc dynamic public var isUserSick: Bool {
        get {
            return bool(forKey: Key.isUserSick)
        }
        set {
            setValue(newValue, forKey: Key.isUserSick)
        }
    }

    @objc dynamic public var didUserMakeContactWithSickUser: Bool {
        get {
            return bool(forKey: Key.didUserMakeContactWithSickUser)
        }
        set {
            setValue(newValue, forKey: Key.didUserMakeContactWithSickUser)
        }
    }

    @objc dynamic public var isContactEventLoggingEnabled: Bool {
        get {
            return bool(forKey: Key.isContactEventLoggingEnabled)
        }
        set {
            setValue(newValue, forKey: Key.isContactEventLoggingEnabled)
        }
    }

    @objc dynamic public var lastContactEventsDownloadDate: Date? {
        get {
            return object(forKey: Key.lastContactEventsDownloadDate) as? Date
        }
        set {
            setValue(newValue, forKey: Key.lastContactEventsDownloadDate)
        }
    }

    @objc dynamic public var isFirstTimeUser: Bool {
        get {
            return bool(forKey: Key.isFirstTimeUser)
        }
        set {
            setValue(newValue, forKey: Key.isFirstTimeUser)
        }
    }

    @objc dynamic public var lastTestedDate: Date? {
        get {
            return object(forKey: Key.lastTestedDate) as? Date
        }
        set {
            setValue(newValue, forKey: Key.lastTestedDate)
        }
    }

}
