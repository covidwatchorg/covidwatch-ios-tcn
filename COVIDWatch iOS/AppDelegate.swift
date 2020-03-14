//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var bluetoothController: BluetoothController?
    
    var isCurrentUserSickObservation: NSKeyValueObservation?
    
    var localContactEventsUploader: LocalContactEventsUploader?
    var publicContactEventsObserver: PublicContactEventsObserver?
    var currentUserExposureNotifier: CurrentUserExposureNotifier?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let actionsAfterLoading = {
            UserDefaults.standard.register(defaults: UserDefaults.Key.registration)
            self.configureCurrentUserNotificationCenter()
            self.requestUserNotificationAuthorization(provisional: false)
            self.configureIsCurrentUserSickObserver()
            self.localContactEventsUploader = LocalContactEventsUploader()
            self.publicContactEventsObserver = PublicContactEventsObserver()
            self.currentUserExposureNotifier = CurrentUserExposureNotifier()
            self.bluetoothController = BluetoothController()
            self.bluetoothController?.start()
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Save changes in the application's managed object context when the application transitions to the background.
        if PersistentContainer.shared.isLoaded {
            PersistentContainer.shared.saveContext()
        }
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
    
}
