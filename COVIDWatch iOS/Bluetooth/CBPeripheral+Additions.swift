//
//  Created by Zsombor Szabo on 31/03/2020.
//

import Foundation
import CoreBluetooth

extension CBPeripheral {
    
    func characteristics(with uuid: CBUUID) -> Set<CBCharacteristic> {
        var result = Set<CBCharacteristic>()
        self.services?.forEach({ (service) in
            service.characteristics?.forEach({ (characteristic) in
                if characteristic.uuid == uuid {
                    result.insert(characteristic)
                }
            })
        })
        return result
    }
    
}
