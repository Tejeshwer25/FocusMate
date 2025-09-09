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
}


extension StatsViewModel {
    struct GraphMockData: Identifiable, Codable {
        var id = UUID()
        let date: Date
        let time: Double
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
