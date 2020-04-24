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
    var advertisedTcns = [Data]()

    var isContactTracingEnabledObservation: NSKeyValueObservation?
    var isCurrentUserSickObservation: NSKeyValueObservation?
    
    var currentUserExposureNotifier: CurrentUserExposureNotifier?
    
    static func getFirestore() -> Firestore {
        if getAppScheme() == .development {
            if let f = FirebaseApp.app() {
                // override the firestore host to use the local emulator
                let firestore = Firestore.firestore(app: f)
                let settings = FirestoreSettings()
                settings.host = getLocalFirebaseHost()
                settings.isSSLEnabled = false
                firestore.settings = settings
                return firestore
            }
        }
        return Firestore.firestore()
    }
    
    var signedReportsUploader: SignedReportsUploader?

    // swiftlint:disable:next function_body_length
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window?.tintColor = UIColor(named: "tintColor")
        
        let appScheme = getAppScheme()
        let apiUrl = getAPIUrl(appScheme)

        print("Starting app with: \(appScheme) and API Url: \(apiUrl)")

        // Override point for customization after application launch.
        FirebaseApp.configure()
        if #available(iOS 13.0, *) {
            self.registerBackgroundTasks()
        } else {
            UIApplication.shared.setMinimumBackgroundFetchInterval(
                UIApplication.backgroundFetchIntervalMinimum
            ) // iOS 12 or earlier
        }
        let actionsAfterLoading = {
            UserDefaults.standard.register(defaults: UserDefaults.Key.registration)
            self.configureCurrentUserNotificationCenter()
            self.requestUserNotificationAuthorization(provisional: true)
            self.configureIsCurrentUserSickObserver()
            self.signedReportsUploader = SignedReportsUploader()
            self.currentUserExposureNotifier = CurrentUserExposureNotifier()
            self.configureContactTracingService()
            self.configureContactTracingEnabledObserver()
        }

        PersistentContainer.shared.load { error in
            if let error = error {
                // build nested confirm delete alert
                let confirmDeleteController = UIAlertController(
                    title: NSLocalizedString("Confirm", comment: ""),
                    message: nil, preferredStyle: .alert
                )
                confirmDeleteController.addAction(
                    UIAlertAction(
                        title: NSLocalizedString("Delete Data", comment: ""),
                        style: .destructive, handler: { _ in
                            PersistentContainer.shared.delete()
                            abort()
                        }
                    )
                )
                confirmDeleteController.addAction(
                    UIAlertAction(
                        title: NSLocalizedString("Quit", comment: ""),
                        style: .cancel, handler: { _ in
                            abort()
                        }
                    )
                )

                // build main alert
                let alertController = UIAlertController(
                    title: NSLocalizedString("Error Loading Data", comment: ""),
                    message: error.localizedDescription, preferredStyle: .alert
                )
                alertController.addAction(
                    UIAlertAction(
                        title: NSLocalizedString("Delete Data", comment: ""),
                        style: .destructive, handler: { _ in
                            UIApplication.shared.topViewController?.present(
                                confirmDeleteController, animated: true, completion: nil
                            )
                        }
                    )
                )
                alertController.addAction(
                    UIAlertAction(
                        title: NSLocalizedString("Quit", comment: ""),
                        style: .cancel, handler: { _ in
                            abort()
                        }
                    )
                )
                UIApplication.shared.topViewController?.present(alertController, animated: true, completion: nil)
                return // should we be returning here?
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
            } else {
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

    private func configureContactTracingEnabledObserver() {
        self.isContactTracingEnabledObservation = UserDefaults.standard.observe(
            \.isContactTracingEnabled, options: [.initial, .new]
        ) { [weak self] (_, change) in
            guard let self = self else { return }
            if change.newValue ?? true {
                self.tcnBluetoothService?.start()
            } else {
                self.tcnBluetoothService?.stop()
            }
        }
    }

    private func configureIsCurrentUserSickObserver() {
        self.isCurrentUserSickObservation = UserDefaults.standard.observe(
            \.isUserSick, options: [.new]
        ) { [weak self] (_, change) in
            guard let self = self else { return }
            guard change.newValue == true else {
                return
            }
            self.generateAndUploadReport()
        }
    }

}
