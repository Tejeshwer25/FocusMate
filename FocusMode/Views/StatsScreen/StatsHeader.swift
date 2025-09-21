//
//  StatsHeader.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import SwiftUI

struct StatsHeader: View {
    let statsHeaderData: StatsViewModel.StatsHeaderData
    
    var body: some View {
        Section("Summary") {
            HStack {
                Text("Time focused today: ")
                Spacer()
                Text("\(self.statsHeaderData.timeFocusedToday)hr")
            }
            
            HStack {
                Text("Sessions Completed: ")
                Spacer()
                Text("\(self.statsHeaderData.sessionsCompleted)")
            }
            
            HStack {
                Text("Sessions Abandoned: ")
                Spacer()
                Text("\(self.statsHeaderData.sessionsAbandoned)")
            }
            
            HStack {
                Text("Current Streak: ")
                Spacer()
                Text("\(self.statsHeaderData.currentStreak) Days")
            }
        }
    }
}

#Preview {
    let headerData = StatsViewModel.StatsHeaderData(
        timeFocusedToday: 5,
        sessionsCompleted: 10,
        sessionsAbandoned: 2,
        currentStreak: 5
    )
    return StatsHeader(statsHeaderData: headerData)
}
