//
//  BluetoothPermission.swift
//  COVIDWatch iOS
//
//  Created by Madhava Jay on 13/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import CoreBluetooth

typealias BluetoothPermissionCallback = () -> Void

class BluetoothPermission: NSObject, CBCentralManagerDelegate {
    static let sharedInstance = BluetoothPermission()
    override private init() {}
    var centralManager: CBCentralManager?
    var allowed: BluetoothPermissionCallback?
    var denied: BluetoothPermissionCallback?

    func checkPermission(_ allowed: @escaping () -> Void, _ denied: @escaping () -> Void) {
        self.centralManager = CBCentralManager()
        self.allowed = allowed
        self.denied = denied
        self.centralManager?.delegate = self
    }

    var isAuthorized: Bool {
        if #available(iOS 13.0, *) {
            return self.centralManager?.authorization == .allowedAlways
        }
        return CBPeripheralManager.authorizationStatus() == .authorized
    }

    func clearCallbacks() {
        self.allowed = nil
        self.denied = nil
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if self.isAuthorized {
            BluetoothPermission.sharedInstance.allowed?()
            self.clearCallbacks()
        } else {
            BluetoothPermission.sharedInstance.denied?()
            self.clearCallbacks()
        }
    }
}
