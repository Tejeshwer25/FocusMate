//
//  DashboardViewModel.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 30/08/25.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {    
    /// Method to get info from FocusSessionEntity
    /// - Parameter session: Focus session entity
    /// - Returns: User task model
    func getUserSessionInfo(from session: FocusSessionEntity) -> UserTaskModel {
        let type = TaskType(rawValue: session.task?.type ?? "") ?? .chores
            return UserTaskModel(
                id: session.id ?? UUID(),
                taskName: session.name ?? type.getTaskName(),
                type: type,
                timeAllotted: CGFloat(session.durationAllotted),
                timeCompleted: CGFloat(session.durationCompleted),
                wasCompleted: false 
            )
    }
    
    /// Method to get readable string for UI from time data
    /// - Parameter sessions: session completed today
    /// - Returns: string representing time completed today
    func getTimeStringForUI(from sessions: FetchedResults<FocusSessionEntity>) -> String {
        let totalDurationCompleted = self.getTotalFocusTimeForToday(from: sessions)
        let timeCompleted = FormatUtil.convertSecondsToRequiredTime(seconds: totalDurationCompleted)
        
        return FormatUtil.getReadableStringFromTime(time: timeCompleted)
    }
    
    /// Method to get total focus time in form of double
    /// - Parameter sessions: Total sessions completed today
    /// - Returns: total time completed today
    func getTotalFocusTimeForToday(from sessions: FetchedResults<FocusSessionEntity>) -> Double {
        var totalDurationCompleted: Double = 0
        
        for session in sessions {
            let timeCompleted = session.durationCompleted
            totalDurationCompleted += timeCompleted
        }
        
        return totalDurationCompleted
    }
    
    /// Method to get time string from session time property
    /// - Parameter seconds: time in float
    /// - Returns: time in representable format
    func getReadableTime(from seconds: CGFloat) -> String {
        let secondsDouble = Double(seconds)
        let time = FormatUtil.convertSecondsToRequiredTime(seconds: secondsDouble)
        let timeString = FormatUtil.getReadableStringFromTime(time: time)
        
        return timeString
    }
}
