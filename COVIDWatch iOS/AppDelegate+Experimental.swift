//
//  Created by Zsombor Szabo on 03/04/2020.
//

import Foundation
import CoreBluetooth
import os.log

//extension AppDelegate : CBCentralManagerDelegate {
extension AppDelegate {
    
    func stopScan() {
        self.bluetoothController?.stop()
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Stop",
                log: .app
            )
        }
    }
    
    func startScan() {
        self.bluetoothController?.start()
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Start",
                log: .app
            )
        }
    }
        
}
