//
//  StatsViewModel.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import Foundation

class StatsViewModel: ObservableObject {
    func sampleData(for duration: GraphPlotOptions) -> [GraphMockData] {
        let calendar = Calendar.current
        let now = Date()
        
        switch duration {
        case .day:
            // 24 hours for today
            return (0..<24).map { hour in
                let timeSpent = Double.random(in: 0...2) // e.g., up to 2 hrs in an hour slot
                let date = calendar.date(byAdding: .hour, value: -hour, to: now)!
                return GraphMockData(date: date, time: timeSpent)
            }.reversed()
            
        case .week:
            // 7 days
            return (0..<7).map { day in
                let timeSpent = Double.random(in: 0...8) // up to 8 hrs per day
                let date = calendar.date(byAdding: .day, value: -day, to: now)!
                return GraphMockData(date: date, time: timeSpent)
            }.reversed()
            
        case .month:
            // 30 days
            return (0..<30).map { day in
                let timeSpent = Double.random(in: 0...8) // up to 8 hrs per day
                let date = calendar.date(byAdding: .day, value: -day, to: now)!
                return GraphMockData(date: date, time: timeSpent)
            }.reversed()
        }
    }
    
    func generateFocusScoreMockData() -> [FocusScoreMockData] {
        let tasks = TaskType.allCases
        var data: [FocusScoreMockData] = []
        
        for dayOffset in 0..<30 {
            let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: .now)!
            
            for task in tasks {
                let score = Double.random(in: 40...100) // random completion %
                data.append(
                    FocusScoreMockData(taskName: task.rawValue, date: date, score: score)
                )
            }
        }
        
        return data
    }
    
    func getTaskBreakdownData() -> [TaskBreakdown] {
        return [
            TaskBreakdown(
                taskType: .exercise,
                sessions: [
                    Session(title: "Morning Run", completionPercent: 90, date: Date()),
                    Session(title: "Yoga", completionPercent: 80, date: Date().addingTimeInterval(-86400)),
                    Session(title: "Gym Workout", completionPercent: 100, date: Date().addingTimeInterval(-172800))
                ]
            ),
            TaskBreakdown(
                taskType: .creative,
                sessions: [
                    Session(title: "Digital Painting", completionPercent: 75, date: Date()),
                    Session(title: "Guitar Practice", completionPercent: 85, date: Date().addingTimeInterval(-86400))
                ]
            ),
            TaskBreakdown(
                taskType: .chores,
                sessions: [
                    Session(title: "Clean Kitchen", completionPercent: 100, date: Date()),
                    Session(title: "Laundry", completionPercent: 70, date: Date().addingTimeInterval(-86400)),
                    Session(title: "Organize Desk", completionPercent: 60, date: Date().addingTimeInterval(-172800))
                ]
            ),
            TaskBreakdown(
                taskType: .learning,
                sessions: [
                    Session(title: "SwiftUI Study", completionPercent: 95, date: Date()),
                    Session(title: "DSA Practice", completionPercent: 85, date: Date().addingTimeInterval(-86400)),
                    Session(title: "Read Book", completionPercent: 60, date: Date().addingTimeInterval(-172800))
                ]
            ),
            TaskBreakdown(
                taskType: .work,
                sessions: [
                    Session(title: "Bug Fixes", completionPercent: 100, date: Date()),
                    Session(title: "Feature Development", completionPercent: 80, date: Date().addingTimeInterval(-86400))
                ]
            )
        ]
    }
}


extension StatsViewModel {
    struct GraphMockData: Identifiable, Codable {
        var id = UUID()
        let date: Date
        let time: Double
    }
    
    struct FocusScoreMockData: Identifiable {
        let id = UUID()
        let taskName: String
        let date: Date
        let score: Double
    }
    
    struct TaskBreakdown: Identifiable {
        let id = UUID()
        let taskType: TaskType
        let sessions: [Session]
        
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
        let completionPercent: Int
        let date: Date
    }
    
    enum GraphPlotOptions: String, CaseIterable, Identifiable {
        case day
        case week
        case month
        
        var id: String {
            rawValue
        }
    }
}
