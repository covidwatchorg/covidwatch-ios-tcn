//
//  Created by Zsombor Szabo on 29/03/2020.
//

import Foundation
import BackgroundTasks
import os.log

extension String {
    
    public static let refreshBackgroundTaskIdentifier = "org.covidwatch.ios.app-refresh"
    public static let processingBackgroundTaskIdentifier = "org.covidwatch.ios.processing"
}

@available(iOS 13.0, *)
extension AppDelegate {
    
    func registerBackgroundTasks() {
        let taskIdentifiers: [String] = [
            .refreshBackgroundTaskIdentifier,
            .processingBackgroundTaskIdentifier
        ]
        taskIdentifiers.forEach { identifier in
            let success = BGTaskScheduler.shared.register(
                forTaskWithIdentifier: identifier,
                using: nil
            ) { task in
                os_log(
                    "Start background task=%@",
                    log: .app,
                    identifier
                )
                self.handleBackground(task: task)
            }
            os_log(
                "Register background task=%@ success=%d",
                log: .app,
                type: success ? .default : .error,
                identifier,
                success
            )
        }
    }
    
    func handleBackground(task: BGTask) {
        switch task.identifier {
            case .refreshBackgroundTaskIdentifier:
                guard let task = task as? BGAppRefreshTask else { break }
                self.handleBackgroundAppRefresh(task: task)
            case .processingBackgroundTaskIdentifier:
                guard let task = task as? BGProcessingTask else { break }
                self.handleBackgroundProcessing(task: task)
            default:
                task.setTaskCompleted(success: false)
        }
    }
    
    func handleBackgroundAppRefresh(task: BGAppRefreshTask) {
        // Schedule a new task
        self.scheduleBackgroundAppRefreshTask()
        self.fetchSignedReports(task: task)
    }
    
    func fetchSignedReports(task: BGAppRefreshTask?) {
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
            task?.setTaskCompleted(success: false)
            return
        }
        
        task?.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
            queue.cancelAllOperations()
        }
        
        lastOperation.completionBlock = {
            let success = !lastOperation.isCancelled
            if success {
                UserDefaults.shared.setValue(now, forKey: UserDefaults.Key.lastFetchDate)
            }
            task?.setTaskCompleted(success: success)
        }
        
        queue.addOperations(operations, waitUntilFinished: false)
    }
    
    func handleBackgroundProcessing(task: BGProcessingTask) {
        // Schedule a new task
        self.scheduleBackgroundProcessingTask()
        self.stayAwake(with: task)
    }
    
    func stayAwake(with task: BGTask) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .backgroundRunningTimeout) {
            os_log(
                "End background task=%@",
                log: .app,
                task.identifier
            )
            task.setTaskCompleted(success: true)
        }
    }
    
    func scheduleBackgroundTasks() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
        self.scheduleBackgroundAppRefreshTask()
        self.scheduleBackgroundProcessingTask()
    }
    
    func scheduleBackgroundAppRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: .refreshBackgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: .minimumBackgroundFetchInterval)
        self.submitTask(request: request)
    }
    
    func scheduleBackgroundProcessingTask() {
        //        let request = BGProcessingTaskRequest(identifier: .processingBackgroundTaskIdentifier)
        //        request.requiresNetworkConnectivity = false
        //        request.requiresExternalPower = false
        //        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)
        //        self.submitTask(request: request)
    }
    
    func submitTask(request: BGTaskRequest) {
        do {
            try BGTaskScheduler.shared.submit(request)
            os_log(
                "Submit task request=%@",
                log: .app,
                request.description
            )
        } catch {
            os_log(
                "Submit task request=%@ failed: %@",
                log: .app,
                type: .error,
                request.description,
                error as CVarArg
            )
        }
    }
    
}
