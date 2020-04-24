//
//  BluetoothPermission.swift
//  CovidWatch iOS
//
//  Created by Madhava Jay on 13/4/20.
//
//

import Foundation
import CoreBluetooth

typealias BluetoothPermissionResult = Result<Void, BluetoothPermissionError>
enum BluetoothPermissionError: String, Error {
    case notAuthorized
}

class BluetoothPermission: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager
    var callback: (BluetoothPermissionResult) -> Void
    init(_ callback: @escaping (BluetoothPermissionResult) -> Void) {
        self.centralManager = CBCentralManager()
        self.callback = callback
        super.init()
        self.centralManager.delegate = self
    }

    var isAuthorized: Bool {
        if #available(iOS 13.1, *) {
            return CBCentralManager.authorization == .allowedAlways
        } else if #available(iOS 13.0, *) {
            return self.centralManager.authorization == .allowedAlways
        } else {
            return CBPeripheralManager.authorizationStatus() == .authorized
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if self.isAuthorized {
            self.callback(Result.success(()))
        } else {
            self.callback(.failure(.notAuthorized))
        }
    }
}
