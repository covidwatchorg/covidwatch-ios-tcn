//
//  Created by Zsombor Szabo on 13/03/2020.
//
//

import Foundation
import Firebase

extension TimeInterval {

    // Only fetch contact events from the past 2 weeks
    public static let oldestPublicContactEventsToFetch: TimeInterval = 60*60*24*7*2
}

extension Firestore {

    public struct Collections {
        static let contactEvents = "contact_events"
    }

    public struct Fields {
        static let timestamp = "timestamp"
    }
}
