//
//  Created by Zsombor Szabo on 04/07/2018.
//

import Foundation
import TCNClient

extension UserDefaults {

    public static let shared: UserDefaults = .standard

    public struct Key {
        public static let isUserSick = "isUserSick"
        public static let mostRecentExposureDate = "mostRecentExposureDate"
        public static let isContactTracingEnabled = "isContactTracingEnabled"
        public static let lastFetchDate = "lastFetchDate"
        public static let isFirstTimeUser = "isFirstTimeUser"
        public static let testLastSubmittedDate = "testLastSubmittedDate"
        
        // TemporaryContactKey
        public static let currentTemporaryContactKeyIndex = "currentTemporaryContactKeyIndex"
        public static let currentTemporaryContactKeyReportVerificationPublicKeyBytes =
        "currentTemporaryContactKeyReportVerificationPublicKeyBytes"
        public static let currentTemporaryContactKeyBytes = "currentTemporaryContactKeyBytes"

        public static let registration: [String: Any] = [
            isUserSick: false,
            isContactTracingEnabled: false,
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

    @objc dynamic public var isContactTracingEnabled: Bool {
        get {
            return bool(forKey: Key.isContactTracingEnabled)
        }
        set {
            setValue(newValue, forKey: Key.isContactTracingEnabled)
        }
    }

    @objc dynamic public var lastFetchDate: Date? {
        return object(forKey: Key.lastFetchDate) as? Date
    }
    
    public var currentTemporaryContactKey: TemporaryContactKey? {
        get {
            if let index = UserDefaults.shared.object(
                forKey: UserDefaults.Key.currentTemporaryContactKeyIndex
                ) as? UInt16,
                let reportVerificationPublicKeyBytes = UserDefaults.shared.object(
                    forKey: UserDefaults.Key.currentTemporaryContactKeyReportVerificationPublicKeyBytes
                    ) as? Data,
                let temporaryContactKeyBytes = UserDefaults.shared.object(
                    forKey: UserDefaults.Key.currentTemporaryContactKeyBytes
                    ) as? Data {
                
                return TemporaryContactKey(
                    index: index,
                    reportVerificationPublicKeyBytes: reportVerificationPublicKeyBytes,
                    bytes: temporaryContactKeyBytes
                )
            }
            
            return nil
        }
        set {
            setValue(
                newValue?.index,
                forKey: UserDefaults.Key.currentTemporaryContactKeyIndex
            )
            setValue(
                newValue?.reportVerificationPublicKeyBytes,
                forKey: UserDefaults.Key.currentTemporaryContactKeyReportVerificationPublicKeyBytes
            )
            setValue(
                newValue?.bytes,
                forKey: UserDefaults.Key.currentTemporaryContactKeyBytes
            )
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
