//
//  AppErrors.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 20/10/25.
//

enum AppErrors: Error {
    case taskNameEmpty
    case taskDurationEmpty
    case taskDurationInvalid
    
    case notificationPermissionDenied
    case notificationRequestFailed
    
    var alertMessage: String {
        switch self {
        case .taskDurationEmpty:
            return "Task duration cannot be empty"
        case .taskDurationInvalid:
            return "Task duration should be greater than 0"
        case .taskNameEmpty:
            return "Task name cannot be empty"
        case .notificationPermissionDenied:
            return "Notification permission is not granted"
        case .notificationRequestFailed:
            return "Failed to request notification permission"
        }
    }
}
