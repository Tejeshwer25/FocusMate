//
//  StatsContainerView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import SwiftUI
import Charts

struct StatsContainerView: View {
    // Latest tasks fetched from core data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FocusSessionEntity.startTime, ascending: false)],
        animation: .default
    ) private var latestTasks: FetchedResults<FocusSessionEntity>
    
    @State private var timeDedicatedGraphMode = StatsViewModel.GraphPlotOptions.week.rawValue
    let viewModel = StatsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                StatsHeader(statsHeaderData: self.viewModel.getDataForHeader(from: latestTasks.map({$0})))
                
                StatTimeDedicatedSection(selectedRange: $timeDedicatedGraphMode,
                                         sessionActivities: self.viewModel.getTimeFocused(for: StatsViewModel.GraphPlotOptions(rawValue: self.timeDedicatedGraphMode) ?? .week, from: self.latestTasks.map(\.self)))
                
                StatsFocusScoreSection(taskFocusScore: self.viewModel.generateFocusScoreMockData())
                
                StatsTaskBreakdownView(tasks: self.viewModel.getTaskBreakdownData())
            }
            .navigationTitle("Stats")
        }
    }
}

#Preview {
    StatsContainerView()
}
