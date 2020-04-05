//
//  Created by Zsombor Szabo on 05/04/2020.
//

import Foundation
import Firebase
import CoreData
import os.log

class SignedReportsDownloadOperation: Operation {
    
    private let sinceDate: Date
    
    public var querySnapshot: QuerySnapshot?
    public var error: Error?
    
    init(sinceDate: Date) {
        self.sinceDate = sinceDate
        super.init()
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        os_log("Downloading signed reports...", log: .app)
        Firestore.firestore().collection(Firestore.Collections.signedReports)
            .whereField(Firestore.Fields.timestamp, isGreaterThan: Timestamp(date: self.sinceDate))
            // TODO: isAuthenticatedByHealthOrganization can only be written by an authenticated user
            // .whereField(Firestore.Fields.isAuthenticatedByHealthOrganization, isEqualTo: true)
            .getDocuments { [weak self] (querySnapshot, error) in
                defer {
                    semaphore.signal()
                }
                guard let self = self else { return }
                if let error = error {
                    self.error = error
                    os_log("Downloading signed reports failed: %@", log: .app, type: .error, error as CVarArg)
                    return
                }
                guard let querySnapshot = querySnapshot else { return }
                os_log("Downloaded %d signed report(s)", log: .app, querySnapshot.count)
                self.querySnapshot = querySnapshot
        }
        if semaphore.wait(timeout: .now() + 20) == .timedOut {
            self.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
        }
    }
    
}
