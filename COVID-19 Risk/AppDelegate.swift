//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Combine
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var bluetoothController: BluetoothController?
    
    var isCurrentUserCanceller: AnyCancellable? = nil
    
    var localContactEventsUploader: LocalContactEventsUploader?
    var publicContactEventsObserver: PublicContactEventsObserver?
    var currentUserExposureNotifier: CurrentUserExposureNotifier?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let actionsAfterLoading = {
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
    
    private func configureIsCurrentUserSickObserver() {
        self.isCurrentUserCanceller = UserData.shared.$isCurrentUserSick
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] (value) in
                guard let self = self else { return }
                guard value == true else { return }
                DispatchQueue.main.async {
                    self.localContactEventsUploader?.markAllLocalContactEventsAsPotentiallyInfectious()
                }                
        }
    }    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
