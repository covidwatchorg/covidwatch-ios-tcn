//
//  Created by Zsombor Szabo on 04/07/2018.
//

import Foundation

extension UserDefaults {

    public static let shared: UserDefaults = .standard

    public struct Key {
        public static let isUserSick = "isUserSick"
        public static let mostRecentExposureDate = "mostRecentExposureDate"
        public static let isContactEventLoggingEnabled = "isContactEventLoggingEnabled"
        public static let lastContactEventsDownloadDate = "lastContactEventsDownloadDate"
        public static let isFirstTimeUser = "isFirstTimeUser"
        public static let testLastSubmittedDate = "testLastSubmittedDate"

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
            if let override = ProcessInfo.processInfo.environment["isFirstTimeUser"] {
                return override.bool
                }
            return bool(forKey: Key.isFirstTimeUser)
        }
        set {
            setValue(newValue, forKey: Key.isFirstTimeUser)
        }
    }

    @objc dynamic public var testLastSubmittedDate: Date? {
        get {
            return object(forKey: Key.testLastSubmittedDate) as? Date
        }
        set {
            setValue(newValue, forKey: Key.testLastSubmittedDate)
        }
    }

//    most recent date we've detected that this user was in contact with a reportedly sick user
    @objc dynamic public var mostRecentExposureDate: Date? {
        get {
            return object(forKey: Key.mostRecentExposureDate) as? Date
        }
        set {
            setValue(newValue, forKey: Key.mostRecentExposureDate)
        }
    }

//    Helper function for determining whether user is at risk for COVID
//    NOTE: Do not watch this property. Watch mostRecentExposureDate and use this in the callback
    public var isUserAtRiskForCovid: Bool {
        get {
            if let mostRecentExposureDate = UserDefaults.shared.mostRecentExposureDate {
                return isDWithinXDaysOfToday(D: mostRecentExposureDate, X: 14)
            }
            return false
        }
    }

//    Helper function for determining whether user is eligible to submit (another) test
//    NOTE: Do not watch this property. Watch testLastSubmittedDate and use this in the callback
    public var isEligibleToSubmitTest: Bool {
        get {
            if let testLastSubmittedDate = UserDefaults.shared.testLastSubmittedDate {
                return !isDWithinXDaysOfToday(D: testLastSubmittedDate, X: 14)
            }
            return true
        }
    }
}
