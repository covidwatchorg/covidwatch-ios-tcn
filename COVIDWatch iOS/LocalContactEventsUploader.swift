//
//  Created by Zsombor Szabo on 12/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import CoreData
import os.log
import Firebase

open class LocalContactEventsUploader: NSObject, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<ContactEvent>
    
    private let db = Firestore.firestore()
    
    override init() {
        let managedObjectContext = PersistentContainer.shared.viewContext
        let request: NSFetchRequest<ContactEvent> = ContactEvent.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ContactEvent.timestamp, ascending: false)]
        request.returnsObjectsAsFaults = false
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        self.fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
            self.uploadContactEventsIfNeeded()
        }
        catch {
            os_log("Fetched results controller perform fetch failed: %@", type: .error, error as CVarArg)
        }
    }
    
    private func uploadContactEventsIfNeeded() {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return }
        let contactEventsToUpload = fetchedObjects.filter({ $0.wasPotentiallyInfectious && $0.uploadState == UploadState.notUploaded.rawValue })
        self.uploadContactEvents(contactEventsToUpload)
    }
    
    private func uploadContactEvents(_ contactEvents: [ContactEvent]) {
        guard !contactEvents.isEmpty else { return }
        let batch = self.db.batch()
        contactEvents.forEach { (contactEvent) in
            guard let identifierString = contactEvent.identifier?.uuidString else { return }
            guard let timestamp = contactEvent.timestamp else { return }
            batch.setData([
                Firestore.Fields.timestamp : Timestamp(date: timestamp)
            ], forDocument: db.collection(Firestore.Collections.contactEvents).document(identifierString))
        }
        os_log("Uploading %d contact event(s)...", type: .info, contactEvents.count)
        // Mark local contact events as being uploaded
        contactEvents.forEach({ $0.uploadState = UploadState.uploading.rawValue })
        batch.commit { [weak self] (error) in
            guard let self = self else { return }
            defer {
                try? self.fetchedResultsController.managedObjectContext.save()
            }
            if let error = error {
                os_log("Uploading %d contact event(s) failed: %@", type: .error, contactEvents.count, error as CVarArg)
                contactEvents.forEach({ $0.uploadState = UploadState.notUploaded.rawValue })
                return
            }
            os_log("Uploaded %d contact event(s)", type: .info, contactEvents.count)
            // Mark local contact events as uploaded
            contactEvents.forEach({ $0.uploadState = UploadState.uploaded.rawValue })
        }
    }
    
    public func markAllLocalContactEventsAsPotentiallyInfectious() {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects,
            !fetchedObjects.isEmpty else {
                return
        }
        do {
            fetchedObjects.forEach({ $0.wasPotentiallyInfectious = true })
            try self.fetchedResultsController.managedObjectContext.save()
            os_log("Marked %d contact event(s) as potentially infectious=%d", type: .info, fetchedObjects.count, true)
        }
        catch {
            os_log("Marking %d contact event(s) as potentially infectious=%d failed: %@", type: .error, fetchedObjects.count, true, error as CVarArg)
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.uploadContactEventsIfNeeded()
    }
    
}
