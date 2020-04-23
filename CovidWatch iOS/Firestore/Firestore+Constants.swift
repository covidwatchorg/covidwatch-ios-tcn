//
//  Created by Zsombor Szabo on 13/03/2020.
//
//

import Foundation
import Firebase

extension TimeInterval {
    
    // Only fetch signed reports from the past 2 weeks
    public static let oldestSignedReportsToFetch: TimeInterval = 60*60*24*7*2
    
    // Fetch new signed reports every 6 hours at the earliest
    public static let minimumBackgroundFetchInterval: TimeInterval = 60*60*6
}

extension Firestore {

    public struct Collections {
        static let signedReports = "signed_reports"
    }
    
    public struct Fields {
        static let temporaryContactKeyBytes = "temporary_contact_key_bytes"
        static let endIndex = "end_index"
        static let memoData = "memo_data"
        static let memoType = "memo_type"
        static let reportVerificationPublicKeyBytes = "report_verification_public_key_bytes"
        static let signatureBytes = "signature_bytes"
        static let startIndex = "start_index"
        
        // Set as the server timestamp
        static let timestamp = "timestamp"
        // Anonymous users can't set this field
        static let isAuthenticatedByHealthOrganization = "is_authenticated_by_health_organization"
    }
}
