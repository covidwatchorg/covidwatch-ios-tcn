//
//  Created by Zsombor Szabo on 05/04/2020.
//

import Foundation

import Foundation
import CoreData
import os.log
import Firebase

open class SignedReportsUploader: NSObject, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<SignedReport>
    
    private let db = Firestore.firestore()
    
    override init() {
        let managedObjectContext = PersistentContainer.shared.viewContext
        let request: NSFetchRequest<SignedReport> = SignedReport.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SignedReport.uploadState, ascending: false)]
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "uploadState == %d", UploadState.notUploaded.rawValue)
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        self.fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
            self.uploadSignedReportsIfNeeded()
        }
        catch {
            os_log("Fetched results controller perform fetch failed: %@", log: .app, type: .error, error as CVarArg)
        }
    }
    
    private func uploadSignedReportsIfNeeded() {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return }
        let toUpload = fetchedObjects.filter({ $0.uploadState == UploadState.notUploaded.rawValue })
        self.uploadSignedReports(toUpload)
    }
    
    private func uploadSignedReports(_ signedReports: [SignedReport]) {
        guard !signedReports.isEmpty else { return }

        signedReports.forEach { (signedReport) in

            let signatureBytesBase64EncodedString = signedReport.signatureBytes?.base64EncodedString() ?? ""
            
            os_log("Uploading signed report (%@)...", log: .app, signatureBytesBase64EncodedString)
            signedReport.uploadState = UploadState.uploading.rawValue
            self.db.collection(Firestore.Collections.signedReports).addDocument(data: [
                Firestore.Fields.temporaryContactKeyBytes : signedReport.temporaryContactKeyBytes ?? Data(),
                Firestore.Fields.endIndex : signedReport.endIndex,
                Firestore.Fields.memoData : signedReport.memoData ?? Data(),
                Firestore.Fields.memoType : signedReport.memoType,
                Firestore.Fields.reportVerificationPublicKeyBytes : signedReport.reportVerificationPublicKeyBytes ?? Data(),
                Firestore.Fields.signatureBytes : signedReport.signatureBytes ?? Data(),
                Firestore.Fields.startIndex : signedReport.startIndex,
                Firestore.Fields.timestamp: FieldValue.serverTimestamp()
            ]) { [weak self] error in
                guard let self = self else { return }
                defer {
                    try? self.fetchedResultsController.managedObjectContext.save()
                }
                if let error = error {
                    // TODO: Handle retry
                    os_log("Uploading signed report (%@) failed: %@", log: .app, type: .error, signatureBytesBase64EncodedString, error as CVarArg)
                    signedReport.uploadState = UploadState.notUploaded.rawValue
                    return
                }
                os_log("Uploaded signed report (%@)", log: .app, signatureBytesBase64EncodedString)
                signedReport.uploadState = UploadState.uploaded.rawValue
            }
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.uploadSignedReportsIfNeeded()
    }
    
}
