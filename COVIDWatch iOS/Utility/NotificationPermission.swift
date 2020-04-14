//
//  NotificationPermission.swift
//  COVIDWatch iOS
//
//  Created by Madhava Jay on 14/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import UIKit

typealias NotificationPermissionResult = Result<Void, NotificationPermissionError>
enum NotificationPermissionError: Error {
    case notAuthorized
    case failedWithError(_ error: Error)
}

struct NotificationPermission {
    init(permissions: UNAuthorizationOptions = [.alert, .sound, .badge],
         _ callback: @escaping (NotificationPermissionResult) -> Void
    ) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: permissions
        ) { granted, error in
            if let error = error {
                callback(.failure(.failedWithError(error)))
                return
            } else if !granted {
                callback(.failure(.notAuthorized))
            } else {
                callback(.success(()))
            }
        }
    }
}
