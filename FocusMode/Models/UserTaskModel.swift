//
//  Task.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 15/08/25.
//

import Foundation

/// Model to store details of user task
enum TaskType: String, CaseIterable, Codable {
    case chores
    case exercise
    case work
    case rest
    case learning
    case creative
    
    func getTaskName() -> String {
        switch self {
        case .chores:
            return "Chores 🧹"
        case .exercise:
            return "Excercises 🏋️‍♂️"
        case .work:
            return "Work 💼"
        case .rest:
            return "Rest 😴"
        case .learning:
            return "Learning 📚"
        case .creative:
            return "Creative 🎨"
        }
    }
}

struct UserTaskModel: Codable, Hashable, Identifiable {
    let id: UUID
    let taskName: String
    let type: TaskType
    let timeAlloted: CGFloat
    var timeCompleted: CGFloat
    let wasCompleted: Bool
    
    init(id: UUID = UUID(),
         taskName: String,
         type: TaskType,
         timeAlloted: CGFloat,
         timeCompleted: CGFloat = 0,
         wasCompleted: Bool = false) {
        self.id = id
        self.taskName = taskName
        self.type = type
        self.timeAlloted = timeAlloted
        self.timeCompleted = timeCompleted
        self.wasCompleted = wasCompleted
    }
}
