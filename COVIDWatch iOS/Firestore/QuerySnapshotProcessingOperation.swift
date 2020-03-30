//
//  Created by Zsombor Szabo on 30/03/2020.
//

import Foundation
import Firebase
import CoreData
import os.log

class QuerySnapshotProcessingOperation: Operation {
    var querySnapshot: QuerySnapshot?
    private let context: NSManagedObjectContext
    private let mergingContexts: [NSManagedObjectContext]?
    
    init(context: NSManagedObjectContext, mergingContexts: [NSManagedObjectContext]? = nil) {
        self.context = context
        self.mergingContexts = mergingContexts
        super.init()
    }
    
    override func main() {
        guard let querySnapshot = self.querySnapshot else { return }
        let addedDocuments = querySnapshot.documentChanges.filter({ $0.type == .added }).map({ $0.document })
        guard !isCancelled else { return }
        self.markLocalContactEvents(from: addedDocuments, asPotentiallyInfectious: true)
        guard !isCancelled else { return }
        let removedDocuments = querySnapshot.documentChanges.filter({ $0.type == .removed }).map({ $0.document })
        guard !isCancelled else { return }
        self.markLocalContactEvents(from: removedDocuments, asPotentiallyInfectious: false)
    }
    
    private func markLocalContactEvents(from queryDocumentSnapshots: [QueryDocumentSnapshot], asPotentiallyInfectious infectious: Bool) {
        guard !queryDocumentSnapshots.isEmpty else { return }        
        self.context.performAndWait { [weak self] in
            do {
                guard let self = self else { return }
                let identifiers: [UUID] = queryDocumentSnapshots.compactMap({ UUID(uuidString: $0.documentID) })
                os_log("Marking %d contact event(s) as potentially infectious=%d ...", type: .info, identifiers.count, infectious)
                var allUpdatedObjectIDs = [NSManagedObjectID]()
                try identifiers.chunked(into: 300000).forEach { (identifiers) in
                    guard !self.isCancelled else { return }
                    let batchUpdateRequest = NSBatchUpdateRequest(entity: ContactEvent.entity())
                    batchUpdateRequest.predicate = NSPredicate(format: "identifier IN %@ AND wasPotentiallyInfectious != %d", identifiers, infectious)
                    batchUpdateRequest.resultType = .updatedObjectIDsResultType
                    batchUpdateRequest.propertiesToUpdate = [
                        "wasPotentiallyInfectious" : infectious,
                        // Marking a contact event as not infectious means that it was deleted from the public contact event list.
                        // This means we need the update its uploadState locally.
                        "uploadState" : infectious ? UploadState.uploaded.rawValue : UploadState.notUploaded.rawValue,
                    ]
                    let batchUpdateResult = try context.execute(batchUpdateRequest) as! NSBatchUpdateResult
                    let updatedObjectIDs = batchUpdateResult.result as! [NSManagedObjectID]
                    allUpdatedObjectIDs.append(contentsOf: updatedObjectIDs)
                }
                if !allUpdatedObjectIDs.isEmpty, let mergingContexts = self.mergingContexts {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSUpdatedObjectsKey: allUpdatedObjectIDs], into: mergingContexts)
                }
                os_log("Marked %d contact event(s) as potentially infectious=%d", type: .info, queryDocumentSnapshots.count, infectious)
            }
            catch {
                os_log("Marking contact event(s) as potentially infectious=%d failed: %@", type: .error, infectious, error as CVarArg)
            }
        }
    }
}
