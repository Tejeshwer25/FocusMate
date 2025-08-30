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
    var body: some Scene {
        WindowGroup {
            TabBarViewController()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
