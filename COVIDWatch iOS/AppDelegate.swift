//
//  Created by Zsombor Szabo on 11/03/2020.
//
//

import UIKit
import CoreData
import Firebase
import os.log
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var bluetoothController: BluetoothController?
    
    var isContactEventLoggingEnabledObservation: NSKeyValueObservation?
    var isCurrentUserSickObservation: NSKeyValueObservation?
    
    var localContactEventsUploader: LocalContactEventsUploader?
    var currentUserExposureNotifier: CurrentUserExposureNotifier?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // MARK: logging
        if let sLog = loadLog() {
            logV = sLog
        }
        log("starting")
        // end of logging startup
        
        FirebaseApp.configure()
        if #available(iOS 13.0, *) {
            self.registerBackgroundTasks()
        }
        else {
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum) // iOS 12 or earlier
        }
        let actionsAfterLoading = {
            UserDefaults.standard.register(defaults: UserDefaults.Key.registration)
            self.configureCurrentUserNotificationCenter()
            self.requestUserNotificationAuthorization(provisional: true)
            self.configureIsCurrentUserSickObserver()
            self.localContactEventsUploader = LocalContactEventsUploader()
            self.currentUserExposureNotifier = CurrentUserExposureNotifier()
            self.bluetoothController = BluetoothController()
            self.configureIsContactEventLoggingEnabledObserver()
        }
        PersistentContainer.shared.load { error in
            if let error = error {
                let alertController = UIAlertController(title: NSLocalizedString("Error Loading Data", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Delete Data", comment: ""), style: .destructive, handler: { _ in
                    let confirmDeleteController = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: nil, preferredStyle: .alert)
                    confirmDeleteController.addAction(UIAlertAction(title: NSLocalizedString("Delete Data", comment: ""), style: .destructive, handler: { _ in
                        PersistentContainer.shared.delete()
                        abort()
                    }))
                    confirmDeleteController.addAction(UIAlertAction(title: NSLocalizedString("Quit", comment: ""), style: .cancel, handler: { _ in
                        abort()
                    }))
                    UIApplication.shared.topViewController?.present(confirmDeleteController, animated: true, completion: nil)
                }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Quit", comment: ""), style: .cancel, handler: { _ in
                    abort()
                }))
                UIApplication.shared.topViewController?.present(alertController, animated: true, completion: nil)
                return
            }
            actionsAfterLoading()
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        PersistentContainer.shared.load { (error) in
            guard error == nil else { return }
            if #available(iOS 13.0, *) {
                self.fetchPublicContactEvents(task: nil)
            }
            else {
                self.fetchPublicContactEvents(completionHandler: nil)
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Save changes in the application's managed object context when the application transitions to the background.
        if PersistentContainer.shared.isLoaded {
            PersistentContainer.shared.saveContext()
        }
        if #available(iOS 13.0, *) {
            self.scheduleBackgroundTasks()
        }
    }
    
    private func configureIsContactEventLoggingEnabledObserver() {
        self.isContactEventLoggingEnabledObservation = UserDefaults.standard.observe(\.isContactEventLoggingEnabled, options: [.initial, .new], changeHandler: { [weak self] (_, change) in
            guard let self = self else { return }
            if change.newValue ?? true {
                self.bluetoothController?.start()
            }
            else {
                self.bluetoothController?.stop()
            }
        })
    }
    
    private func configureIsCurrentUserSickObserver() {
        self.isCurrentUserSickObservation = UserDefaults.standard.observe(\.isCurrentUserSick, options: [.new], changeHandler: { [weak self] (_, change) in
            guard let self = self else { return }
            guard change.newValue == true else {
                return
            }
            self.localContactEventsUploader?.markAllLocalContactEventsAsPotentiallyInfectious()
        })
    }
    
    
    // MARK: View Logging:
    
    var logV = [LogLine]()
    var logViewController : LogViewController?

    func log(_ s: String) {
        let line = LogLine.formatD(Date()) + ":" + s
        logV.append(LogLine(line:line))
        logViewController?.log(line)
        saveLog()
    }
    
    private func saveLog() {
        //        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: logV, requiringSecureCoding: false)
        //        try! archivedData.write(to: LogLine.ArchiveURL)
        if let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: logV, requiringSecureCoding: false) {
            do {
                try archivedData.write(to: LogLine.ArchiveURL)
            } catch {
                os_log("saving failed.1", log: OSLog.default, type: .debug)
            }
        } else {
            os_log("saving failed.2", log: OSLog.default, type: .debug)
        }
    }
    
    private func loadLog() -> [LogLine]? {
        //return NSKeyedUnarchiver.unarchiveObject(withFile: LogLine.ArchiveURL.path) as? [LogLine]
        //        let archivedData = try! Data(contentsOf: LogLine.ArchiveURL)
        //        return (try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [LogLine]
        if let archivedData = try? Data(contentsOf: LogLine.ArchiveURL) {
            if let rv = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [LogLine] {
                return rv
            } else {
                os_log("loading failed.", log: OSLog.default, type: .debug)
                return nil
            }
        } else {
            os_log("loading failed.", log: OSLog.default, type: .debug)
            return nil
        }
        
    }
    
    
    
    
}
