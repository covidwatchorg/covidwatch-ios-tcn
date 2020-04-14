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
typealias PermissionResult = Result<Void, BluetoothPermissionError>
enum BluetoothPermissionError: String, Error {
    case notAuthorized
}

class BluetoothPermission: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager
    var callback: (PermissionResult) -> Void
    init(_ callback: @escaping (PermissionResult) -> Void) {
        self.centralManager = CBCentralManager()
        self.callback = callback
        super.init()
        self.centralManager.delegate = self
    }

    var isAuthorized: Bool {
        if #available(iOS 13.1, *) {
            return CBCentralManager.authorization == .allowedAlways
        }
        if #available(iOS 13.0, *) {
            return self.centralManager.authorization == .allowedAlways
        }
        return CBPeripheralManager.authorizationStatus() == .authorized
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if self.isAuthorized {
            self.callback(Result.success(()))
        } else {
            self.callback(.failure(.notAuthorized))
        }
    }
}
