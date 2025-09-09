//
//  Persistence.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 30/08/25.
//

import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "FocusModel")
        if inMemory {
            // In memory is used for initialization in unit testing and previews
            self.container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        self.container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load core data container \(error.localizedDescription)")
            }
        }
        self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
