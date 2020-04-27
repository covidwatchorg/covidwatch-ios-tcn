//
//  Bluetooth.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//
//

import UIKit

class Notifications: UIViewController {
    
    // MARK: - Properties
    
    private var isCheckingNotificationPermissions = false
    
    // MARK: - IBOutlets
    
    @IBOutlet private var largeText: UILabel!
    @IBOutlet private var mainText: UILabel!
    @IBOutlet private var button: UIButton!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    
    // MARK: - IBActions
    
    @IBAction func btnTapped(_ sender: Any) {
        self.nextScreen()
    }
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self, selector: #selector(nextScreenIfNotificationsEnabled),
            name: UIApplication.willEnterForegroundNotification, object: nil)
        button.update(height: btnHeight)
        self.setupAccessibilityAndLocalization()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let header = segue.destination as? HeaderViewController {
            header.delegate = self
        }
    }
    
    // MARK: - Custom
    
    private func setupAccessibilityAndLocalization() {
        largeText.accessibilityIdentifier = AccessibilityIdentifier.LargeText.rawValue
        mainText.accessibilityIdentifier = AccessibilityIdentifier.MainText.rawValue
        button.accessibilityIdentifier = AccessibilityIdentifier.AllowButton.rawValue
        button.accessibilityLabel = AccessibilityLabel.allowButton
    }
    
    @objc func nextScreenIfNotificationsEnabled() {
        _ = NotificationPermission { [weak self] (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "NotificationsToFinish", sender: self)
                }
            case .failure(let error):
                print("Still no notifications permissions", error)
            }
        }
    }
    
    private func nextScreen() {
        guard !self.isCheckingNotificationPermissions else {
            print("Already checking Notification Permissions")
            return
        }
        self.isCheckingNotificationPermissions = true
        _ = NotificationPermission { [weak self] result in
            self?.isCheckingNotificationPermissions = false
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "NotificationsToFinish", sender: self)
                }
            case .failure:
                print("Please go into settings and enable Notifications")
                DispatchQueue.main.async {
                    self?.present(UIAlertController.notificationAlert, animated: true)
                }
            }
        }
    }
}

// MARK: - Protocol HeaderViewControllerDelegate
extension Notifications: HeaderViewControllerDelegate {
    func menuWasTapped() {
        print("Not Implemented")
    }
    var shouldShowMenu: Bool {
        false
    }
}
