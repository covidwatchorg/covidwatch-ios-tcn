//
//  Created by Zsombor Szabo on 14/03/2020.
//
//

import UIKit
import CoreData
import os.log

class ContactEventsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<ContactEvent>?
    
    var isContactEventLoggingEnabledObservation: NSKeyValueObservation?
    var isContactEventLoggingEnabled: Bool = false {
        didSet {
            configureBarButtonItems(animated: isViewLoaded)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initFetchedResultsController()
        self.configureIsContactEventLoggingObservationEnabled()
    }
    
    func initFetchedResultsController() {
        PersistentContainer.shared.load { error in
            do {
                if let error = error {
                    throw(error)
                }
                let managedObjectContext = PersistentContainer.shared.viewContext
                let request: NSFetchRequest<ContactEvent> = ContactEvent.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \ContactEvent.timestamp, ascending: false)]
                request.returnsObjectsAsFaults = false
                request.fetchBatchSize = 200
                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                self.fetchedResultsController?.delegate = self
                try self.fetchedResultsController?.performFetch()
                self.tableView.reloadData()
            }
            catch {
                os_log("Fetched results controller perform fetch failed: %@", type: .error, error as CVarArg)
            }
        }
    }
    
    @IBOutlet weak var clearBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var startBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var stopBarButtonItem: UIBarButtonItem!
    
    @IBAction func handleTapClearButton(_ sender: UIBarButtonItem) {
        let context = PersistentContainer.shared.newBackgroundContext()
        context.perform {
            do {
                os_log("Deleting contact events...", type: .info)
                guard let entityName = ContactEvent.entity().name else { return }
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeObjectIDs
                let batchDeleteResult = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
                let deletedObjectIDs = batchDeleteResult.result as! [NSManagedObjectID]
                if !deletedObjectIDs.isEmpty {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs], into: [PersistentContainer.shared.viewContext])
                }
                os_log("Deleted %d contact event(s)", type: .info, deletedObjectIDs.count)
            }
            catch {
                os_log("Deleting contact events failed: %@", type: .error, error as CVarArg)
            }
        }
    }
    
    @IBAction func handleTapStartButton(_ sender: UIBarButtonItem) {
        UserDefaults.standard.isContactEventLoggingEnabled = true
    }
    
    @IBAction func handleTapStopButton(_ sender: UIBarButtonItem) {
        UserDefaults.standard.isContactEventLoggingEnabled = false
    }
    
    private func configureBarButtonItems(animated: Bool = false) {
        var items = [UIBarButtonItem]()
        if self.isContactEventLoggingEnabled {
            items.append(stopBarButtonItem)
        }
        else {
            items.append(startBarButtonItem)
        }
        items.append(clearBarButtonItem)
        self.navigationItem.setRightBarButtonItems(items, animated: animated)
    }
            
    private func configureIsContactEventLoggingObservationEnabled() {
        self.isContactEventLoggingEnabledObservation = UserDefaults.standard.observe(\.isContactEventLoggingEnabled, options: [.initial, .new], changeHandler: { [weak self] (_, change) in
            guard let self = self else { return }
            self.isContactEventLoggingEnabled = (change.newValue ?? false)
        })
    }
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactEventRow", for: indexPath)
        if let contactEvent = self.fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = self.dateFormatter.string(from: contactEvent.timestamp!)
            cell.detailTextLabel?.text = contactEvent.identifier?.uuidString
            cell.backgroundColor = contactEvent.wasPotentiallyInfectious ? .systemRed : .systemGreen
        }
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            case .update:
                self.tableView.reloadRows(at: [indexPath!], with: .automatic)
            case .move:
                self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
            @unknown default: ()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
