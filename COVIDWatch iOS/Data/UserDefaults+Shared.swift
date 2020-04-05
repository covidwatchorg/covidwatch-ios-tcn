//
//  Created by Zsombor Szabo on 04/07/2018.
//

import Foundation
import ContactTracingCEN
import CryptoKit

extension UserDefaults {        
    
    public static let shared: UserDefaults = .standard
    
    public struct Key {
        public static let isCurrentUserSick = "isCurrentUserSick"
        public static let wasCurrentUserNotifiedOfExposure = "wasCurrentUserNotifiedOfExposure"
        public static let isContactEventNumberLoggingEnabled = "isContactEventNumberLoggingEnabled"
        public static let lastFetchDate = "lastFetchDate"
        
        // ContactEventKey
        public static let currentContactEventKeyIndex = "currentContactEventKeyIndex"
        public static let currentContactEventKeyReportVerificationPublicKeyBytes = "currentContactEventKeyReportVerificationPublicKeyBytes"
        public static let currentContactEventKeyBytes = "currentContactEventKeyBytes"

        
        public static let registration: [String : Any] = [
            isCurrentUserSick: false,
            wasCurrentUserNotifiedOfExposure: false,
            isContactEventNumberLoggingEnabled: false,
        ]
    }
    
    @objc dynamic public var isCurrentUserSick: Bool {
        return bool(forKey: Key.isCurrentUserSick)
    }
    
    @objc dynamic public var wasCurrentUserNotifiedOfExposure: Bool {
        return bool(forKey: Key.wasCurrentUserNotifiedOfExposure)
    }
    
    @objc dynamic public var isContactEventNumberLoggingEnabled: Bool {
        return bool(forKey: Key.isContactEventNumberLoggingEnabled)
    }
    
    @objc dynamic public var lastFetchDate: Date? {
        return object(forKey: Key.lastFetchDate) as? Date
    }
    
    public var currentContactEventKey: ContactEventKey? {
        get {
            if let index = UserDefaults.shared.object(forKey: UserDefaults.Key.currentContactEventKeyIndex) as? UInt16,
                let reportVerificationPublicKeyBytes = UserDefaults.shared.object(forKey: UserDefaults.Key.currentContactEventKeyReportVerificationPublicKeyBytes) as? Data,
                let contactEventKeyBytes = UserDefaults.shared.object(forKey: UserDefaults.Key.currentContactEventKeyBytes) as? Data {
                
                return ContactEventKey(
                    index: index,
                    reportVerificationPublicKeyBytes: reportVerificationPublicKeyBytes,
                    bytes: contactEventKeyBytes
                )
            }
            
            return nil
        }
        set {
            setValue(newValue?.index, forKey: UserDefaults.Key.currentContactEventKeyIndex)
            setValue(newValue?.reportVerificationPublicKeyBytes, forKey: UserDefaults.Key.currentContactEventKeyReportVerificationPublicKeyBytes)
            setValue(newValue?.bytes, forKey: UserDefaults.Key.currentContactEventKeyBytes)
        }
    }
    
}
