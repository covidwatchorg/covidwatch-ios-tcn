//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import CoreBluetooth

extension BluetoothService {
    
    /// The peripheral service to be added to the local GATT database.
    public static var peripheralService: CBMutableService {
        let service = CBMutableService(
            type: CBUUID(string: UUIDPeripheralServiceString),
            primary: true
        )
        return service
    }
    
    /// The characteristic used for sending configuration.
    public static var contactEventIdentifierCharacteristic: CBMutableCharacteristic {
        return CBMutableCharacteristic(
            type: CBUUID(
                string: BluetoothService.UUIDContactEventIdentifierCharacteristicString
            ),
            properties: [.read],
            value: nil,
            permissions: [.readable]
        )
    }
}
