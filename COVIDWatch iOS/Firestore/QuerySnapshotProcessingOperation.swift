//
//  Created by Zsombor Szabo on 30/03/2020.
//

import Foundation
import Firebase
import CoreData
import os.log
import ContactTracingCEN

// TODO: split this operation into an add to core data and a process signed reports operation
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
        self.markFoundContactEventsNumbersAsPotentiallyInfectious(from: addedDocuments)
    }
    
    private func markFoundContactEventsNumbersAsPotentiallyInfectious(from queryDocumentSnapshots: [QueryDocumentSnapshot]) {
        guard !queryDocumentSnapshots.isEmpty else { return }        
        self.context.performAndWait { [weak self] in
            do {
                guard let self = self else { return }
                
                try queryDocumentSnapshots.forEach { (snapshot) in
                    guard !self.isCancelled else { return }
                    
                    let snapshotData = snapshot.data()
                    
                    if let contactEventKeyBytes = snapshotData[Firestore.Fields.contactEventKeyBytes] as? Data,
                        let endPeriod = snapshotData[Firestore.Fields.endPeriod] as? UInt16,
                        let memoData = snapshotData[Firestore.Fields.memoData] as? Data,
                        let memoType = snapshotData[Firestore.Fields.memoType] as? UInt8,
                        let reportVerificationPublicKeyBytes = snapshotData[Firestore.Fields.reportVerificationPublicKeyBytes] as? Data,
                        let signatureBytes = snapshotData[Firestore.Fields.signatureBytes] as? Data,
                        let startPeriod = snapshotData[Firestore.Fields.startPeriod] as? UInt16 {
                        
                        let report = Report(reportVerificationPublicKeyBytes: reportVerificationPublicKeyBytes, contactEventKeyBytes: contactEventKeyBytes, startPeriod: startPeriod, endPeriod: endPeriod, memoType: MemoType(rawValue: memoType) ?? MemoType.CovidWatchV1, memoData: memoData)
                        
                        let signedReport = ContactTracingCEN.SignedReport(report: report, signatureBytes: signatureBytes)
                        
                        let signatureBytesBase64EncodedString = signedReport.signatureBytes.base64EncodedString()
                        do {
                            _ = try signedReport.verify()
                            os_log("Source integrity verification for signed report (%@) succeeded", log: .app, signatureBytesBase64EncodedString)
                        }
                        catch {
                            os_log("Source integrity verification for signed report (%@) failed: %@", log: .app, type: .error, signatureBytesBase64EncodedString, error as CVarArg)
                            return
                        }
                        
                        let managedSignedReport = SignedReport(context: context)
                        managedSignedReport.isProcessed = false
                        managedSignedReport.configure(with: signedReport)
                        
                        // Long-running operation
                        let recomputedContactEventNumbers = signedReport.report.getContactEventNumbers()
                        
                        guard !self.isCancelled else { return }
                        
                        let identifiers: [Data] = recomputedContactEventNumbers.compactMap({ $0.bytes })
                        
                        os_log("Marking %d contact event numbers(s) as potentially infectious=%d ...", log: .app, identifiers.count, true)
                        
                        var allUpdatedObjectIDs = [NSManagedObjectID]()
                        try identifiers.chunked(into: 300000).forEach { (identifiers) in
                            guard !self.isCancelled else { return }
                            let batchUpdateRequest = NSBatchUpdateRequest(entity: ContactEventNumber.entity())
                            batchUpdateRequest.predicate = NSPredicate(format: "bytes IN %@", identifiers, true)
                            batchUpdateRequest.resultType = .updatedObjectIDsResultType
                            batchUpdateRequest.propertiesToUpdate = [
                                "wasPotentiallyInfectious" : true,
                            ]
                            let batchUpdateResult = try context.execute(batchUpdateRequest) as! NSBatchUpdateResult
                            let updatedObjectIDs = batchUpdateResult.result as! [NSManagedObjectID]
                            allUpdatedObjectIDs.append(contentsOf: updatedObjectIDs)
                        }
                        
                        managedSignedReport.isProcessed = true
                        
                        if !allUpdatedObjectIDs.isEmpty, let mergingContexts = self.mergingContexts {
                            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSUpdatedObjectsKey: allUpdatedObjectIDs], into: mergingContexts)
                        }
                        
                        os_log("Marked %d contact event number(s) as potentially infectious=%d", log: .app, identifiers.count, true)
                    }
                }
            }
            catch {
                os_log("Marking contact event number(s) as potentially infectious=%d failed: %@", log: .app, type: .error, true, error as CVarArg)
            }
        }
    }
}
