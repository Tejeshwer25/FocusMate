//
//  TaskList.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 15/08/25.
//

import Foundation

/// Data model to store user's task list for a specific date
struct UserTaskListModel: Codable {
    let date: Date
    let tasks: [UserTaskModel]
    
    init(date: Date = Date(),
         tasks: [UserTaskModel] = []) {
        self.date = date
        self.tasks = tasks
    }
}
