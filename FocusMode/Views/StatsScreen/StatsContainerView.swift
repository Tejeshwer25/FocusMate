//
//  StatsContainerView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import SwiftUI
import Charts

struct StatsContainerView: View {
    let viewModel = StatsViewModel()
    private var sessionsCreated: [FocusSessionEntity]? {
        return self.latestTasks.map(\.self)
    }
    
    @State private var timeDedicatedGraphMode = StatsViewModel.GraphPlotOptions.week.rawValue
    
    // Latest tasks fetched from core data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FocusSessionEntity.startTime, ascending: false)],
        animation: .default
    ) private var latestTasks: FetchedResults<FocusSessionEntity>
    
    var body: some View {
        NavigationStack {
            List {
                StatsHeader(statsHeaderData: self.viewModel.getDataForHeader(from: latestTasks.map({$0})))
                
                if self.viewModel.shouldShowCharts(for: self.sessionsCreated) {
                    StatTimeDedicatedSection(selectedRange: $timeDedicatedGraphMode,
                                             sessionActivities: self.viewModel.getTimeFocused(for: StatsViewModel.GraphPlotOptions(rawValue: self.timeDedicatedGraphMode) ?? .week, from: self.sessionsCreated))
                    
                    if (self.sessionsCreated?.count ?? 0) <= 5 {
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
