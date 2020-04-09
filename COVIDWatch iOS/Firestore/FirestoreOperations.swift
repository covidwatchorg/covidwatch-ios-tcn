//
//  Created by Zsombor Szabo on 30/03/2020.
//

import Foundation
import CoreData

struct FirestoreOperations {
    
    // Returns an array of operations for fetching the latest entries and then adding them to the Core Data store.
    static func getOperationsToDownloadContactEvents(sinceDate: Date, using context: NSManagedObjectContext, mergingContexts: [NSManagedObjectContext]? = nil) -> [Operation] {
        let downloadOperation = ContactEventsDownloadOperation(sinceDate: sinceDate)
        let processingOperation = QuerySnapshotProcessingOperation(context: context, mergingContexts: mergingContexts)
        let passDownloadResultsToProcessing = BlockOperation { [unowned downloadOperation, unowned processingOperation] in
            guard let querySnapshot = downloadOperation.querySnapshot else {
                processingOperation.cancel()
                return
            }
            processingOperation.querySnapshot = querySnapshot
        }
        passDownloadResultsToProcessing.addDependency(downloadOperation)
        processingOperation.addDependency(passDownloadResultsToProcessing)
        return [downloadOperation, passDownloadResultsToProcessing, processingOperation]
    }
    
}
