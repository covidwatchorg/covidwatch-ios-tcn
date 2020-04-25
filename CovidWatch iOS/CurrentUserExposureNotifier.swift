//
//  Created by Zsombor Szabo on 13/03/2020.
//
//

import UIKit
import CoreData
import os.log
import Firebase

open class CurrentUserExposureNotifier: NSObject, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<TemporaryContactNumber>
    
    private var alertContorller: UIAlertController?
    
    override init() {
        let managedObjectContext = PersistentContainer.shared.viewContext
        let fetchRequest: NSFetchRequest<TemporaryContactNumber> = TemporaryContactNumber.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TemporaryContactNumber.foundDate, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "wasPotentiallyInfectious == 1")
        fetchRequest.returnsObjectsAsFaults = true
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        self.fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            os_log("Fetched results controller perform fetch failed: %@", log: .app, type: .error, error as CVarArg)
        }
    }
    
    public func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        // No need to notify current user of exposure if they reported themselves sick
        guard !UserDefaults.standard.isUserSick else {
            return
        }
        guard type == .insert else {
            return
        }
        self.notifyCurrentUserOfExposureIfNeeded()
    }
    
    private func notifyCurrentUserOfExposureIfNeeded() {
        if let tcn = fetchedResultsController.fetchedObjects?.first {
            UserDefaults.shared.mostRecentExposureDate = tcn.foundDate
        }
        if UIApplication.shared.applicationState == .background {
            (UIApplication.shared.delegate as? AppDelegate)?.showCurrentUserExposedUserNotification()
        }
    }
}
