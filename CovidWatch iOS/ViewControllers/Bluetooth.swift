//
//  Bluetooth.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  
//

import UIKit

class Bluetooth: UIViewController {
    
    // MARK: - Properties
    
    var bluetoothPermission: BluetoothPermission?
    var isCheckingBluetoothPermissions = false
    
    // MARK: - IBOutlets
    
    @IBOutlet var largeText: UILabel!
    @IBOutlet var mainText: UILabel!
    @IBOutlet var button: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func btnTapped(_ sender: Any) {
        self.nextScreen()
    }
    
    // MARK: - UIViewController methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let header = segue.destination as? HeaderViewController {
            header.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibilityAndLocalization()
    }
    
    // MARK: - Custom
    
    private func setupAccessibilityAndLocalization() {
        largeText.accessibilityIdentifier = AccessibilityIdentifier.LargeText.rawValue
        mainText.accessibilityIdentifier = AccessibilityIdentifier.MainText.rawValue
        button.accessibilityIdentifier = AccessibilityIdentifier.AllowButton.rawValue
        button.accessibilityLabel = AccessibilityLabel.allowButton
    }
    
    func nextScreen() {
        self.isCheckingBluetoothPermissions = true
        self.bluetoothPermission = BluetoothPermission { [weak self] (result) in
            self?.isCheckingBluetoothPermissions = false
            switch result {
            case .success:
                if UserDefaults.standard.isContactTracingEnabled == false {
                    UserDefaults.standard.isContactTracingEnabled = true
                }
                self?.performSegue(withIdentifier: "BluetoothToNotifications", sender: self)
            case .failure:
                print("Please go into settings and enable Bluetooth")
                self?.present(UIAlertController.bluetoothAlert, animated: true)
            }
        }
    }
}

// MARK: - Protocol HeaderViewControllerDelegate
extension Bluetooth: HeaderViewControllerDelegate {
    
    func menuWasTapped() {
        print("Not Implemented")
    }
    
    var shouldShowMenu: Bool {
        false
    }
}
