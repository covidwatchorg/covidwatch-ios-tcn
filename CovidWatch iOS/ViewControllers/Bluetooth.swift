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
    
    private var bluetoothPermission: BluetoothPermission?
    private var isCheckingBluetoothPermissions = false
    
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
        setupAccessibilityAndLocalization()
        button.update(height: btnHeight)
        UserDefaults.standard.checkIfStartedOnboarding = true
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
    
    private func nextScreen() {
        guard !self.isCheckingBluetoothPermissions else {
            print("Already Checking Bluetooth Permissions.")
            return
        }
        
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
