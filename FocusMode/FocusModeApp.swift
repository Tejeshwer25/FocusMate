//
//  FocusModeApp.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 14/08/25.
//

import SwiftUI

@main
struct FocusModeApp: App {
    let persistenceController = PersistenceController.shared
    let notificationManager = NotificationManager.sharedInstance
    
    var body: some Scene {
        WindowGroup {
            TabBarViewController()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notificationManager)
                .task {
                    do {
                        try await notificationManager.requestNotification()
                    } catch {
                        print("Failure to request notification authorization: \(error.localizedDescription)")
                    }
                }
        }
    }
}
