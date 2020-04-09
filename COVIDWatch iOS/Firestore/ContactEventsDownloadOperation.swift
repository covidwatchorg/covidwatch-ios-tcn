//
//  Created by Zsombor Szabo on 30/03/2020.
//

import Foundation
import Firebase
import CoreData
import os.log

class ContactEventsDownloadOperation: Operation {

    private let sinceDate: Date

    public var querySnapshot: QuerySnapshot?
    public var error: Error?

    init(sinceDate: Date) {
        self.sinceDate = sinceDate
        super.init()
    }

    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        os_log("Downloading contact events...", type: .info)
        Firestore.firestore().collection(Firestore.Collections.contactEvents)
            .whereField(Firestore.Fields.timestamp, isGreaterThan: Timestamp(date: self.sinceDate))
            .getDocuments { [weak self] (querySnapshot, error) in
                defer {
                    semaphore.signal()
                }
                guard let self = self else { return }
                if let error = error {
                    self.error = error
                    os_log("Downloading contact events failed: %@", type: .error, error as CVarArg)
                    return
                }
                guard let querySnapshot = querySnapshot else { return }
                os_log("Downloaded %d contact event(s)", type: .info, querySnapshot.count)
                self.querySnapshot = querySnapshot
        }
        if semaphore.wait(timeout: .now() + 20) == .timedOut {
            self.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
        }
    }

}
