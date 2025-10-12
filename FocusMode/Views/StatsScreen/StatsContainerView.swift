//
//  StatsContainerView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import SwiftUI
import Charts

struct StatsContainerView: View {
    @StateObject var viewModel = StatsViewModel()
    
    // Latest tasks fetched from core data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FocusSessionEntity.startTime, ascending: false)],
        animation: .default
    ) private var latestTasks: FetchedResults<FocusSessionEntity>
    // Get mapped focus session entity from Fetched Results
    private var sessionsCreated: [FocusSessionEntity] {
        Array(latestTasks)
    }
    
    var body: some View {
        NavigationStack {
            List {
                StatsHeader(statsHeaderData: self.viewModel.getDataForHeader(from: self.sessionsCreated))
                
                if self.viewModel.shouldShowCharts(for: self.sessionsCreated) {
                    StatTimeDedicatedSection(selectedRange: $viewModel.timeDedicatedGraphMode,
                                             sessionActivities: self.viewModel.getTimeFocused(from: self.sessionsCreated))
                    
                    if self.sessionsCreated.count >= 5 {
                        StatsFocusScoreSection(taskFocusScore: self.viewModel.getFocusScorePerDayData(from: self.sessionsCreated))
                    }
                    
                    StatsTaskBreakdownView(tasks: self.viewModel.getGroupedSessions(from: self.sessionsCreated))
                }
            }
            .navigationTitle("Stats")
        }
    }
}

#Preview {
    StatsContainerView()
}
