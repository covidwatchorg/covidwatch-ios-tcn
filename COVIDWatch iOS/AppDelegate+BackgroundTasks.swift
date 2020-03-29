//
//  Created by Zsombor Szabo on 29/03/2020.
//

import Foundation
import BackgroundTasks
import os.log

extension String {
    
    public static let refreshBackgroundTaskIdentifier = "org.covidwatch.ios.app-refresh"
    public static let processBackgroundTaskIdentifier = "org.covidwatch.ios.processing"
}

@available(iOS 13.0, *)
extension AppDelegate {
    
    func registerBackgroundTasks() {
        let taskIdentifiers: [String] = [
            .refreshBackgroundTaskIdentifier,
            .processBackgroundTaskIdentifier
        ]
        taskIdentifiers.forEach { identifier in
            let success = BGTaskScheduler.shared.register(
                forTaskWithIdentifier: identifier,
                using: nil
            ) { task in
                os_log(
                    "Start background task=%@",
                    type: .info,
                    identifier
                )
                self.handleBackground(task: task)
            }
            os_log(
                "Register background task=%@ success=%d",
                type: success ? .info : .error,
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
            case .processBackgroundTaskIdentifier:
                guard let task = task as? BGProcessingTask else { break }
                self.handleBackgroundProcessing(task: task)
            default: ()
        }
    }
    
    func handleBackgroundAppRefresh(task: BGAppRefreshTask) {
        // Schedule a new task
        self.scheduleBackgroundAppRefreshTask()
        self.stayAwake(with: task)
    }
        
    func handleBackgroundProcessing(task: BGProcessingTask) {
        // Schedule a new task
        self.scheduleBackgroundProcessingTask()
        self.stayAwake(with: task)
    }
    
    func stayAwake(with task: BGTask) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .stayAwakeTimeout) {
            os_log(
                "End background task=%@",
                type: .info,
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
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)
        request.earliestBeginDate = nil
        self.submitTask(request: request)
    }
    
    func scheduleBackgroundProcessingTask() {
//        let request = BGProcessingTaskRequest(identifier: .processBackgroundTaskIdentifier)
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
                type: .info,
                request.description
            )
        } catch {
            os_log(
                "Submit task request=%@ failed: %@",
                type: .error,
                request.description,
                error as CVarArg
            )
        }
    }
    
}
