//
//  NotificationManager.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 20/10/25.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, ObservableObject, Observable {
    static let sharedInstance = NotificationManager()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        
        self.userNotificationCenter.delegate = self
    }
    
    /// Method to request notification from user
    func requestNotification() async throws {
        if await self.checkIfNotificationsAuthorized() == false {
            try await userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        }
    }
    
    /// Method to check if notification permission is allowed from user
    /// - Returns: If user has provided notification permission or not
    private func checkIfNotificationsAuthorized() async -> Bool {
        let settings = await userNotificationCenter.notificationSettings()
        
        guard (settings.authorizationStatus == .authorized) || (settings.authorizationStatus == .provisional) else {
            return false
        }
        
        return true
    }
    
    /// Generic method to handle all local notification to be sent to user
    func sendUserNotifications(identifier: String,
                               title: String,
                               message: String) async throws {
        if await checkIfNotificationsAuthorized() == false {
            throw AppErrors.notificationPermissionDenied
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = message
        notificationContent.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        do {
            try await self.userNotificationCenter.add(.init(identifier: identifier,
                                                            content: notificationContent,
                                                            trigger: trigger))
        } catch {
            throw AppErrors.notificationRequestFailed
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show banner + sound while in foreground
        completionHandler([.banner, .sound])
    }
    
    // Handle interaction with a delivered notification if needed
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // You can inspect response.notification.request.identifier or response.actionIdentifier
        completionHandler()
    }
}
