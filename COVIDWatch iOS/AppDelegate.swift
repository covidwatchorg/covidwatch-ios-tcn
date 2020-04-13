//
//  Created by Zsombor Szabo on 11/03/2020.
//
//

import UIKit
import CoreData
import Firebase
import os.log
import BackgroundTasks
import TCNClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var tcnBluetoothService: TCNBluetoothService?
    
    var isTemporaryContactNumberLoggingEnabledObservation: NSKeyValueObservation?
    var isCurrentUserSickObservation: NSKeyValueObservation?
    
    var signedReportsUploader: SignedReportsUploader?
    var currentUserExposureNotifier: CurrentUserExposureNotifier?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window?.tintColor = UIColor(red: 50.0/255.0, green: 90.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        if #available(iOS 13.0, *) {
            self.registerBackgroundTasks()
        }
        else {
            UIApplication.shared.setMinimumBackgroundFetchInterval(.minimumBackgroundFetchInterval) // iOS 12 or earlier
        }
        let actionsAfterLoading = {
            UserDefaults.standard.register(defaults: UserDefaults.Key.registration)
            self.configureCurrentUserNotificationCenter()
            self.requestUserNotificationAuthorization(provisional: true)
            self.configureIsCurrentUserSickObserver()
            self.signedReportsUploader = SignedReportsUploader()
            self.currentUserExposureNotifier = CurrentUserExposureNotifier()
            self.configureContactTracingService()
            self.configureIsTemporaryContactNumberLoggingEnabledObserver()
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
                self.fetchSignedReports(task: nil)
            }
            else {
                self.fetchSignedReports(completionHandler: nil)
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
    
    private func configureIsTemporaryContactNumberLoggingEnabledObserver() {
        self.isTemporaryContactNumberLoggingEnabledObservation = UserDefaults.standard.observe(\.isTemporaryContactNumberLoggingEnabled, options: [.initial, .new], changeHandler: { [weak self] (_, change) in
            guard let self = self else { return }
            if change.newValue ?? true {
                self.tcnBluetoothService?.start()
            }
            else {
                self.tcnBluetoothService?.stop()
            }
        })
    }
    
    private func configureIsCurrentUserSickObserver() {        
//        self.isCurrentUserSickObservation = UserDefaults.standard.observe(\.isCurrentUserSick, options: [.new], changeHandler: { [weak self] (_, change) in
//            guard let self = self else { return }
//            guard change.newValue == true else {
//                return
//            }
//            // TODO: Handle the case of uploading new reports after the fact the user has reported sick
//            self.generateAndUploadReport()
//        })
    }
    
}
