//
//  Created by Zsombor Szabo on 04/07/2018.
//

import Foundation
import TCNClient
import CryptoKit

extension UserDefaults {        
    
    public static let shared: UserDefaults = .standard
    
    public struct Key {
        public static let isCurrentUserSick = "isCurrentUserSick"
        public static let wasCurrentUserNotifiedOfExposure = "wasCurrentUserNotifiedOfExposure"
        public static let isTemporaryContactNumberLoggingEnabled = "isTemporaryContactNumberLoggingEnabled"
        public static let lastFetchDate = "lastFetchDate"
        
        // TemporaryContactKey
        public static let currentTemporaryContactKeyIndex = "currentTemporaryContactKeyIndex"
        public static let currentTemporaryContactKeyReportVerificationPublicKeyBytes = "currentTemporaryContactKeyReportVerificationPublicKeyBytes"
        public static let currentTemporaryContactKeyBytes = "currentTemporaryContactKeyBytes"

        
        public static let registration: [String : Any] = [
            isCurrentUserSick: false,
            wasCurrentUserNotifiedOfExposure: false,
            isTemporaryContactNumberLoggingEnabled: true,
        ]
    }
    
    @objc dynamic public var isCurrentUserSick: Bool {
        return bool(forKey: Key.isCurrentUserSick)
    }
    
    @objc dynamic public var wasCurrentUserNotifiedOfExposure: Bool {
        return bool(forKey: Key.wasCurrentUserNotifiedOfExposure)
    }
    
    @objc dynamic public var isTemporaryContactNumberLoggingEnabled: Bool {
        return bool(forKey: Key.isTemporaryContactNumberLoggingEnabled)
    }
    
    @objc dynamic public var lastFetchDate: Date? {
        return object(forKey: Key.lastFetchDate) as? Date
    }
    
    public var currentTemporaryContactKey: TemporaryContactKey? {
        get {
            if let index = UserDefaults.shared.object(forKey: UserDefaults.Key.currentTemporaryContactKeyIndex) as? UInt16,
                let reportVerificationPublicKeyBytes = UserDefaults.shared.object(forKey: UserDefaults.Key.currentTemporaryContactKeyReportVerificationPublicKeyBytes) as? Data,
                let temporaryContactKeyBytes = UserDefaults.shared.object(forKey: UserDefaults.Key.currentTemporaryContactKeyBytes) as? Data {
                
                return TemporaryContactKey(
                    index: index,
                    reportVerificationPublicKeyBytes: reportVerificationPublicKeyBytes,
                    bytes: temporaryContactKeyBytes
                )
            }
            
            return nil
        }
        set {
            setValue(newValue?.index, forKey: UserDefaults.Key.currentTemporaryContactKeyIndex)
            setValue(newValue?.reportVerificationPublicKeyBytes, forKey: UserDefaults.Key.currentTemporaryContactKeyReportVerificationPublicKeyBytes)
            setValue(newValue?.bytes, forKey: UserDefaults.Key.currentTemporaryContactKeyBytes)
        }
    }
    
}
