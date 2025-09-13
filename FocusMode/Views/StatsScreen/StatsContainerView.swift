//
//  StatsContainerView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import SwiftUI
import Charts

struct StatsContainerView: View {
    @State private var timeDedicatedGraphMode = StatsViewModel.GraphPlotOptions.week.rawValue
    let viewModel = StatsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                StatsHeader()
                
                StatTimeDedicatedSection(selectedRange: $timeDedicatedGraphMode,
                                         sessionActivities: self.viewModel.sampleData(for: StatsViewModel.GraphPlotOptions(rawValue: self.timeDedicatedGraphMode) ?? .week))
                
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
