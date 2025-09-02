//
//  DashboardViewModel.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 30/08/25.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    typealias Time = (hour: Int, minutes: Int, second: Int)
    
    /// Method to get info from FocusSessionEntity
    /// - Parameter session: Focus session entity
    /// - Returns: User task model
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
    
    /// Method to get readable string for UI from time data
    /// - Parameter sessions: session completed today
    /// - Returns: string representing time completed today
    func getTimeStringForUI(from sessions: FetchedResults<FocusSessionEntity>) -> String {
        let totalDurationCompleted = self.getTotalFocusTimeForToday(from: sessions)
        let timeCompleted = self.convertSecondsToRequiredTime(seconds: totalDurationCompleted)
        
        return self.getReadableStringFromTime(time: timeCompleted)
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
    
    /// Method to convert seconds to respective time format
    /// - Parameter seconds: seconds completed
    /// - Returns: time completed
    func convertSecondsToRequiredTime(seconds: Double) -> Time {
        let hours = Int(seconds) / 3600
        let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600))) / 60
        let seconds = Int((seconds.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        return Time(hour: hours, minutes: minutes, second: seconds)
    }
    
    /// Method to get readable string from time format
    /// - Parameter time: Time data tuple
    /// - Returns: readable string
    func getReadableStringFromTime(time: Time) -> String {
        var result = ""
        if time.hour > 0 {
            result += "\(time.hour)h "
        }
        
        if time.minutes > 0 {
            result += "\(time.minutes)m "
        }
        
        if time.second > 0 {
            result += "\(time.second)s "
        }
        
        return result
    }
}
