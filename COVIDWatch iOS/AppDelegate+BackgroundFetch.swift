//
//  Created by Zsombor Szabo on 29/03/2020.
//

import UIKit
import os.log
import BackgroundTasks

extension TimeInterval {
    
    // Note: Using values higher than 30 seconds will result in the system killing the app
    public static let backgroundRunningTimeout: TimeInterval = 3
}

extension AppDelegate {
    
    // iOS 12 or earlier
    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        os_log("Performing background fetch...", log: .app)
        self.fetchSignedReports(completionHandler: completionHandler)
    }
    
    public func fetchSignedReports(completionHandler: ((UIBackgroundFetchResult) -> Void)?) {
        let now = Date()
        let oldestDownloadDate = now.addingTimeInterval(-.oldestSignedReportsToFetch)
        var downloadDate = UserDefaults.shared.lastFetchDate ?? oldestDownloadDate
        if downloadDate < oldestDownloadDate {
            downloadDate = oldestDownloadDate
        }
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let operations = FirestoreOperations.getOperationsToDownloadSignedReports(
            sinceDate: downloadDate,
            using: PersistentContainer.shared.newBackgroundContext(),
            mergingContexts: [PersistentContainer.shared.viewContext]
        )
        
        guard let lastOperation = operations.last else {
            completionHandler?(.failed)
            return
        }
        
        lastOperation.completionBlock = {
            let success = !lastOperation.isCancelled
            if success {
                UserDefaults.shared.setValue(now, forKey: UserDefaults.Key.lastFetchDate)
                if let downloadOperation = operations.first as? SignedReportsDownloadOperation,
                    let querySnapshot = downloadOperation.querySnapshot,
                    querySnapshot.count > 0 {
                    completionHandler?(.newData)
                }
                else {
                    completionHandler?(.noData)
                }
            }
            else {
                completionHandler?(.failed)
            }
        }
        
        queue.addOperations(operations, waitUntilFinished: false)        
    }
}
