//
//  StatsViewModel.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import Foundation

typealias SessionsCompletedAndAbandonedCount = (sessionsCompleted: Int, sessionsAbandoned: Int)

class StatsViewModel: ObservableObject {    
    /// Method to get data for header section
    /// - Parameter from: focus session entity containing all data
    /// - Returns: Data for stats header view
    func getDataForHeader(from allSessions: [FocusSessionEntity]) -> StatsHeaderData {
        let timeFocusedToday = self.getTimeFocusedToday(from: allSessions)
        let sessionsCompletedAndAbandonedCount = self.getSessionsCompletedAndAbandonedData(from: allSessions)
        let userStreak = self.getUserStreak(from: allSessions)
        
        let data = StatsHeaderData(timeFocusedToday: Int(timeFocusedToday),
                                   sessionsCompleted: sessionsCompletedAndAbandonedCount.sessionsCompleted,
                                   sessionsAbandoned: sessionsCompletedAndAbandonedCount.sessionsAbandoned,
                                   currentStreak: userStreak)
        return data
    }
    
    /// Method to get time focused today from all the session created by user
    /// - Parameter sessions: session created
    /// - Returns: total time focused today
    func getTimeFocusedToday(from sessions: [FocusSessionEntity]) -> Double {
        return sessions.map { session in
            if let sessionStartTime = session.startTime {
                if Calendar.current.isDate(sessionStartTime, inSameDayAs: Date()) {
                    return session.durationCompleted
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }.reduce(0.0) { partialResult, time in
            partialResult + time
        }
    }
    
    /// Method to get count for sessions completed and abandoned from list of all sessions
    /// - Parameter sessions: all sessions created
    /// - Returns: count for sessions completed and abandoned respectively in form of tuple
    func getSessionsCompletedAndAbandonedData(from sessions: [FocusSessionEntity]) -> SessionsCompletedAndAbandonedCount {
        return sessions.reduce(SessionsCompletedAndAbandonedCount(0,0)) { partialResult, session in
            let durationCompleted = session.durationCompleted
            let durationAlloted = session.durationAlloted
            
            if durationAlloted < durationCompleted {
                return (sessionsCompleted: partialResult.sessionsCompleted + 1,
                        sessionsAbandoned: partialResult.sessionsAbandoned)
            } else {
                return (sessionsCompleted: partialResult.sessionsCompleted,
                        sessionsAbandoned: partialResult.sessionsAbandoned + 1)
            }
        }
    }
    
    /// Method to get users current streak from all sessions created
    /// - Parameter sessions: all sessions created by user
    /// - Returns: Current active streak
    func getUserStreak(from sessions: [FocusSessionEntity]) -> Int {
        if sessions.count == 0 { return 0 }
        
        let format = "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        var currentStartDate = sessions.first?.startTime
        var currentStreak = 0
        
        for session in sessions {
            let formattedCurrentDate = formatter.date(from: formatter.string(from: currentStartDate ?? Date())) ?? Date()
            let formattedSessionDate = formatter.date(from: formatter.string(from: session.startTime ?? Date())) ?? Date()
            
            if Calendar.current.isDate(formattedSessionDate, inSameDayAs: formattedCurrentDate) {
                if currentStreak == 0 && formattedSessionDate == formatter.date(from: formatter.string(from: Date())) {
                    currentStreak += 1
                }
                // Both are same days
                currentStartDate = session.startTime
                continue
            } else if Calendar.current.date(byAdding: .day, value: 1, to: formattedSessionDate) == formattedCurrentDate {
                currentStartDate = session.startTime
                currentStreak += 1
            } else {
                break
            }
        }
        
        return currentStreak
    }
    
    /// Method to get time focus on a particular task for a given time range
    /// - Parameters:
    ///   - duration: range for which to calculate durationg
    ///   - sessions: sessions data
    /// - Returns: plottable data
    func getTimeFocused(for duration: GraphPlotOptions,
                        from sessions: [FocusSessionEntity]?) -> [GraphMockData] {
        var timeFocusedData = [GraphMockData]()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        func isInRange(_ date: Date) -> Bool {
            switch duration {
            case .day:
                return calendar.isDate(date, inSameDayAs: today)
                
            case .week:
                if let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) {
                    return date >= weekAgo
                }
                return false
                
            case .month:
                if let monthAgo = calendar.date(byAdding: .day, value: -31, to: today) {
                    return date >= monthAgo
                }
                return false
            }
        }
        
        for session in (sessions ?? []) {
            let sessionDate = calendar.startOfDay(for: session.endTime ?? Date())
            guard isInRange(sessionDate) else { continue }
            
            if let index = timeFocusedData.firstIndex(where: { $0.date == sessionDate }) {
                timeFocusedData[index].completedTime += session.durationCompleted
                timeFocusedData[index].allotedTIme += session.durationAlloted
            } else {
                timeFocusedData.append(.init(
                    date: sessionDate,
                    completedTime: session.durationCompleted,
                    allotedTIme: session.durationAlloted
                ))
            }
        }
        
        return timeFocusedData
    }
    
    /// Method to get focus score from per day data
    /// - Parameter sessions: focus sessions
    /// - Returns: per day change in focus score
    func getFocusScorePerDayData(from sessions: [FocusSessionEntity]?) -> [FocusScoreMockData] {
        var focusScoreData: [FocusScoreMockData] = []
        
        for session in (sessions ?? []) {
            let sessionDate = Calendar.current.startOfDay(for: session.endTime ?? Date())
            
            if let index = focusScoreData.firstIndex(where: { $0.date == sessionDate }) {
                focusScoreData[index].tasksOnDate += 1
                focusScoreData[index].meanScore += session.durationAlloted * session.focusScore
                focusScoreData[index].meanTimeAlloted += session.durationAlloted
            } else {
                let newData = FocusScoreMockData(taskName: session.task?.type,
                                                 date: sessionDate,
                                                 tasksOnDate: 1,
                                                 score: 0,
                                                 meanScore: session.durationAlloted * session.focusScore,
                                                 meanTimeAlloted: session.durationAlloted)
                focusScoreData.append(newData)
            }
        }
        
        for index in 0..<focusScoreData.count {
            let session = focusScoreData[index]
            let score = session.meanScore / session.meanTimeAlloted
            
            focusScoreData[index].score = score
        }
        
        return focusScoreData
    }
    
    /// Method to get grouped tasks from all created tasks
    /// - Parameter sessions: session created till date
    /// - Returns: session grouped based on type
    func getGroupedSessions(from sessions: [FocusSessionEntity]?) -> [TaskBreakdown] {
        var groupedSessions = [TaskBreakdown]()
        
        for session in (sessions ?? []) {
            let completionPercent = (session.durationCompleted / session.durationAlloted) * 100
            let currentSession = Session(title: session.name ?? "n/a",
                                         completionPercent: completionPercent,
                                         date: session.endTime ?? Date())
            
            if let index = groupedSessions.firstIndex(where: { $0.taskType.rawValue == session.task?.type }) {
                groupedSessions[index].sessions.append(currentSession)
            } else {
                let taskType = TaskType(rawValue: session.task?.type ?? "") ?? .chores
                
                let task = TaskBreakdown(taskType: taskType, sessions: [currentSession])
                groupedSessions.append(task)
            }
        }
        
        return groupedSessions
    }
}


extension StatsViewModel {
    struct StatsHeaderData {
        let timeFocusedToday: Int // In minutes
        let sessionsCompleted: Int
        let sessionsAbandoned: Int
        let currentStreak: Int
    }
    
    struct TaskBreakdown: Identifiable {
        let id = UUID()
        let taskType: TaskType
        var sessions: [Session]
        
        var totalSessions: Int {
            sessions.count
        }
        
        var averageCompletion: Double {
            guard !sessions.isEmpty else { return 0 }
            let total = sessions.reduce(0) { $0 + $1.completionPercent }
            return Double(total) / Double(sessions.count)
        }
    }
    
    struct Session: Identifiable {
        let id = UUID()
        let title: String
        let completionPercent: Double
        let date: Date
    }
    
    struct GraphMockData: Identifiable, Codable {
        var id = UUID()
        let date: Date
        var completedTime: Double
        var allotedTIme: Double
    }
    
    enum GraphPlotOptions: String, CaseIterable, Identifiable {
        case day
        case week
        case month
        
        var id: String {
            rawValue
        }
    }
    
    
    struct FocusScoreMockData: Identifiable {
        let id = UUID()
        let taskName: String?
        let date: Date
        var tasksOnDate: Int
        var score: Double
        var meanScore: Double
        var meanTimeAlloted: Double
    }
}
