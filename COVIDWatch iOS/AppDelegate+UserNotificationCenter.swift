//
//  Created by Zsombor SZABO on 20/09/2017.
//

import UserNotifications
import UIKit
import os.log

extension UNNotificationCategory {
    
    public static let currentUserExposed = "currentUserExposed"
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: User Notification Center
    
    func configureCurrentUserNotificationCenter() {
        let center = UNUserNotificationCenter.current()
        // Exposed: Message, View
        let currentUserExposedCategory = UNNotificationCategory(identifier: UNNotificationCategory.currentUserExposed, actions: [], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: NSLocalizedString("Exposed", comment: ""), categorySummaryFormat: nil, options: [])
        center.setNotificationCategories([currentUserExposedCategory])
        center.delegate = self
    }
    
    public func showCurrentUserExposedUserNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.categoryIdentifier = UNNotificationCategory.currentUserExposed
        notificationContent.sound = .defaultCritical
        // When exporting for localizations Xcode doesn't look for NSString.localizedUserNotificationString(forKey:, arguments:))
        _ = NSLocalizedString("You have been possibly exposed to someone who you have recently been in contact with, and who has subsequently self-reported as having the virus.", comment: "")
        notificationContent.body = NSString.localizedUserNotificationString(forKey: "You have been possibly exposed to someone who you have recently been in contact with, and who has subsequently self-reported as having the virus.", arguments: nil)
        let notificationRequest = UNNotificationRequest(identifier: UNNotificationCategory.currentUserExposed, content: notificationContent, trigger:
            UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false))
        addToCurrentUserNotificationCenterNotificationRequest(notificationRequest)
    }
    
    private func addToCurrentUserNotificationCenterNotificationRequest(_ notificationRequest: UNNotificationRequest) {
      UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else { return }
        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
        os_log("Added notification request (.identifier=%@ .content.categoryIdentifier=%@ .content.threadIdentifier=%@) to user notification center.", log: .app, notificationRequest.identifier, notificationRequest.content.categoryIdentifier, notificationRequest.content.threadIdentifier)
      })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // We will update .badge in the app
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func requestUserNotificationAuthorization(provisional: Bool = true) {
        let options:UNAuthorizationOptions = provisional ? [.alert, .sound, .badge, .providesAppNotificationSettings, .provisional] : [.alert, .sound, .badge, .providesAppNotificationSettings]
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { (granted, error) in
            DispatchQueue.main.async {
                if let error = error {
                    UIApplication.shared.topViewController?.present(error as NSError, animated: true)
                    return
                }
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    }
    
}
