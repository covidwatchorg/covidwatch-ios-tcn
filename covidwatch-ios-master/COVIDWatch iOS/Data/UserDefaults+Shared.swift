//
//  Created by Zsombor Szabo on 04/07/2018.
//

import Foundation

extension UserDefaults {        
    
    public static let shared: UserDefaults = .standard
    
    public struct Key {
        public static let isCurrentUserSick = "isCurrentUserSick"
        public static let wasCurrentUserNotifiedOfExposure = "wasCurrentUserNotifiedOfExposure"
        public static let isContactEventLoggingEnabled = "isContactEventLoggingEnabled"
        public static let lastContactEventsDownloadDate = "lastContactEventsDownloadDate"
        
        public static let registration: [String : Any] = [
            isCurrentUserSick: false,
            wasCurrentUserNotifiedOfExposure: false,
            isContactEventLoggingEnabled: false,
        ]
    }
    
    @objc dynamic public var isCurrentUserSick: Bool {
        get {
            return bool(forKey: Key.isCurrentUserSick)
        }
        set {
            setValue(newValue, forKey: Key.isCurrentUserSick)
        }
    }
    
    @objc dynamic public var wasCurrentUserNotifiedOfExposure: Bool {
        get {
            return bool(forKey: Key.wasCurrentUserNotifiedOfExposure)
        }
        set {
            setValue(newValue, forKey: Key.wasCurrentUserNotifiedOfExposure)
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
    
}
