//
//  Created by Zsombor Szabo on 13/03/2020.
//
//

import Foundation
import Firebase
import CoreData
import os.log

open class PublicContactEventsObserver: NSObject {
    
    override init() {
        super.init()
        // Only observe the contact events from the past 2 weeks
        Firestore.firestore().collection(Firestore.Collections.contactEvents)
            .whereField(Firestore.Fields.timestamp, isGreaterThan: Timestamp(date: Date().addingTimeInterval(-60*60*24*7*2)))
            .addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                os_log("Listening for realtime updates of contact events failed: %@", type: .error, error as CVarArg)
                return
            }
            guard let querySnapshot = querySnapshot else { return }
            os_log("Listened for realtime updates of %d contact event(s)", type: .info, querySnapshot.count)
            DispatchQueue.global(qos: .background).async {
                let addedDocuments = querySnapshot.documentChanges.filter({ $0.type == .added }).map({ $0.document })
                self.markLocalContactEvents(from: addedDocuments, asPotentiallyInfectious: true)
                let removedDocuments = querySnapshot.documentChanges.filter({ $0.type == .removed }).map({ $0.document })
                self.markLocalContactEvents(from: removedDocuments, asPotentiallyInfectious: false)
            }
        }
    }
    
    private func markLocalContactEvents(from queryDocumentSnapshots: [QueryDocumentSnapshot], asPotentiallyInfectious infectious: Bool) {
        guard !queryDocumentSnapshots.isEmpty else { return }
        let context = PersistentContainer.shared.newBackgroundContext()
        context.perform {
            do {
                let identifiers: [UUID] = queryDocumentSnapshots.compactMap({ UUID(uuidString: $0.documentID) })
                os_log("Marking %d contact event(s) as potentially infectious=%d ...", type: .info, identifiers.count, infectious)
                var allUpdatedObjectIDs = [NSManagedObjectID]()
                try identifiers.chunked(into: 300000).forEach { (identifiers) in
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
                if !allUpdatedObjectIDs.isEmpty {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSUpdatedObjectsKey: allUpdatedObjectIDs], into: [PersistentContainer.shared.viewContext])
                }
                os_log("Marked %d contact event(s) as potentially infectious=%d", type: .info, queryDocumentSnapshots.count, infectious)
            }
            catch {
                os_log("Marking contact event(s) as potentially infectious=%d failed: %@", type: .error, infectious, error as CVarArg)
            }
        }
    }
}
