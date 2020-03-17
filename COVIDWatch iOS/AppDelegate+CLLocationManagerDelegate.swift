//
//  Created by Zsombor Szabo on 14/03/2020.
//
//

import Foundation
import CoreLocation
import os.log

extension AppDelegate: CLLocationManagerDelegate {
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            return
        }
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        os_log("Location manager did update locations (%d)", type: .info, locations.count)
    }
}
