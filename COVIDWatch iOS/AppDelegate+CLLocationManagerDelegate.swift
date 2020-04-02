//
//  Created by Zsombor Szabo on 02/04/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import CoreLocation
import os.log

extension AppDelegate: CLLocationManagerDelegate {
    
    func configureBackgroundLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.showsBackgroundLocationIndicator = true
        self.locationManager?.pausesLocationUpdatesAutomatically = true
        self.locationManager?.activityType = .automotiveNavigation
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        if let error = error {
            os_log(
                "Did finish deferred updates error=%@",
                log: .app,
                type: .error,
                error as CVarArg
            )
        }
        else {
            os_log(
                "Did finish deferred updates",
                log: .app
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        os_log(
            "Did update location=%d",
            log: .app,
            locations.count
        )
    }
    
}
