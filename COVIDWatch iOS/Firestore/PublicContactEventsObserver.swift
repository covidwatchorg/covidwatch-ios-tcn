//
//  Created by Zsombor Szabo on 13/03/2020.
//
//

import Foundation
import Firebase
import CoreData
import os.log

open class PublicContactEventsObserver: NSObject {

    let operationQueue = OperationQueue()

    override init() {
        super.init()
        // Only observe the contact events from the past 2 weeks
        let twoWeeksAgo = Date().addingTimeInterval(-.oldestPublicContactEventsToFetch)
        Firestore.firestore().collection(Firestore.Collections.contactEvents)
            .whereField(Firestore.Fields.timestamp, isGreaterThan: Timestamp(date: twoWeeksAgo))
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    let errorString = "Listening for realtime updates of contact events failed: %@"
                    os_log(errorString, type: .error, error as CVarArg)
                    UIApplication.shared.topViewController?.present(error as NSError, animated: true)
                    return
                }
                guard let querySnapshot = querySnapshot else { return }
                os_log("Listened for realtime updates of %d contact event(s)", type: .info, querySnapshot.count)
                let processingOperation = QuerySnapshotProcessingOperation(
                    context: PersistentContainer.shared.viewContext,
                    mergingContexts: [PersistentContainer.shared.newBackgroundContext()]
                )
                processingOperation.querySnapshot = querySnapshot
                self.operationQueue.addOperation(processingOperation)
        }
    }
}
