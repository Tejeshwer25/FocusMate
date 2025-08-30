//
//  DashboardViewModel.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 30/08/25.
//

import Foundation

class DashboardViewModel {
    func getUserSessionInfo(from session: FocusSessionEntity) -> UserTaskModel {
        let type = TaskType(rawValue: session.task?.type ?? "") ?? .chores
            return UserTaskModel(
                id: session.id ?? UUID(),
                taskName: session.name ?? type.getTaskName(),
                type: type,
                timeAlloted: CGFloat(session.durationAlloted),
                timeCompleted: CGFloat(session.durationCompleted),
                wasCompleted: false 
            )
    }
}
