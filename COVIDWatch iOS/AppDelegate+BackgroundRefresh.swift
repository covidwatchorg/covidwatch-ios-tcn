//
//  Created by Zsombor Szabo on 29/03/2020.
//

import UIKit
import os.log

extension AppDelegate {
    
    // iOS 12 or earlier
    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        os_log("Performing background fetch...", type: .info)
        DispatchQueue.main.asyncAfter(deadline: .now() + .stayAwakeTimeout) {
            os_log("Performed background fetch", type: .info)
            completionHandler(.newData)
        }
    }
}
