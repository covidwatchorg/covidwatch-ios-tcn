//
//  Created by Zsombor Szabo on 14/03/2020.
//
//

import UIKit
import CoreData
import os.log

class TemporaryContactNumbersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<TemporaryContactNumber>?
    
    var isTemporaryContactLoggingEnabledObservation: NSKeyValueObservation?
    var isTemporaryContactLoggingEnabled: Bool = false {
        didSet {
            configureBarButtonItems(animated: isViewLoaded)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initFetchedResultsController()
        self.configureIsTemporaryContactLoggingObservationEnabled()
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshSignedReports), for: .valueChanged)
    }
    
    @objc private func refreshSignedReports(_ sender: Any) {
        (UIApplication.shared.delegate as? AppDelegate)?.fetchSignedReports(completionHandler: { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl?.endRefreshing()
            }            
        })
    }
    
    func initFetchedResultsController() {
        PersistentContainer.shared.load { error in
            do {
                if let error = error {
                    throw(error)
                }
                let managedObjectContext = PersistentContainer.shared.viewContext
                let request: NSFetchRequest<TemporaryContactNumber> = TemporaryContactNumber.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \TemporaryContactNumber.foundDate, ascending: false)]
                request.returnsObjectsAsFaults = false
                request.fetchBatchSize = 200
                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                self.fetchedResultsController?.delegate = self
                try self.fetchedResultsController?.performFetch()
                self.tableView.reloadData()
                self.configureClearButton()
            }
            catch {
                os_log("Fetched results controller perform fetch failed: %@", log: .app, type: .error, error as CVarArg)
            }
        }
    }
        
    private func configureClearButton() {
//        self.clearBarButtonItem.isEnabled = (self.fetchedResultsController?.fetchedObjects?.count ?? 0) > 0
    }
    
    @IBAction func handleTapClearButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: NSLocalizedString("Clear discovered rolling proximity identifiers (RPI) stored on this device?", comment: ""), message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            ()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Clear", comment: ""), style: .default, handler: { _ in
            let context = PersistentContainer.shared.newBackgroundContext()
            context.perform {
                do {
                    os_log("Deleting temporary contact numbers...", log: .app)
                    guard let entityName = TemporaryContactNumber.entity().name else { return }
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    batchDeleteRequest.resultType = .resultTypeObjectIDs
                    let batchDeleteResult = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
                    let deletedObjectIDs = batchDeleteResult.result as! [NSManagedObjectID]
                    if !deletedObjectIDs.isEmpty {
                        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs], into: [PersistentContainer.shared.viewContext])
                    }
                    os_log("Deleted %d temporary contact number(s)", log: .app, deletedObjectIDs.count)
                }
                catch {
                    os_log("Deleting temporary contacts numbers failed: %@", log: .app, type: .error, error as CVarArg)
                }
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func handleTapStartButton(_ sender: UIBarButtonItem) {
        UserDefaults.standard.setValue(true, forKey: UserDefaults.Key.isTemporaryContactNumberLoggingEnabled)
    }
    
    @IBAction func handleTapStopButton(_ sender: UIBarButtonItem) {
        UserDefaults.standard.setValue(false, forKey: UserDefaults.Key.isTemporaryContactNumberLoggingEnabled)
    }
    
    @IBAction func handleTapDownloadButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: NSLocalizedString("Download self-reports from the cloud?", comment: ""), message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            ()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Download", comment: ""), style: .default, handler: { _ in
            (UIApplication.shared.delegate as? AppDelegate)?.fetchSignedReports(completionHandler: { (result) in
                ()
            })
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func handleTapUploadButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: NSLocalizedString("Upload self-report to the cloud?", comment: ""), message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            ()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Upload", comment: ""), style: .default, handler: { _ in
            (UIApplication.shared.delegate as? AppDelegate)?.generateAndUploadReport()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func configureBarButtonItems(animated: Bool = false) {
//        var items = [UIBarButtonItem]()
//        if self.isTemporaryContactLoggingEnabled {
//            items.append(stopBarButtonItem)
//        }
//        else {
//            items.append(startBarButtonItem)
//        }
//        items.append(clearBarButtonItem)
//        self.navigationItem.setRightBarButtonItems(items, animated: animated)
    }
            
    private func configureIsTemporaryContactLoggingObservationEnabled() {
        self.isTemporaryContactLoggingEnabledObservation = UserDefaults.standard.observe(\.isTemporaryContactNumberLoggingEnabled, options: [.initial, .new], changeHandler: { [weak self] (_, change) in
            guard let self = self else { return }
            self.isTemporaryContactLoggingEnabled = (change.newValue ?? false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemporaryContactRow", for: indexPath)
        if let temporaryContactNumber = self.fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = self.dateFormatter.string(from: temporaryContactNumber.foundDate!)
            cell.detailTextLabel?.text = temporaryContactNumber.bytes?.base64EncodedString()
            cell.backgroundColor = temporaryContactNumber.wasPotentiallyInfectious ? .systemRed : .systemGreen            
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
        self.configureClearButton()
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
