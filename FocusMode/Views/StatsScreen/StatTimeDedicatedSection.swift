//
//  StatTimeDedicatedSection.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import SwiftUI
import Charts

struct StatTimeDedicatedSection: View {
    let sessionActivities: [StatsViewModel.GraphMockData]
    @Binding var selectedRange: String
    @State private var selectedDate: Date?
    
    var body: some View {
        Section("Time Dedicated") {
            VStack {
                Chart(sessionActivities) { session in
                    BarMark(
                        x: .value("Date", session.date, unit: .day),
                        y: .value("Total Count", session.time)
                    )
                }
                .frame(height: 300)
                .padding()
                
                Spacer()
                
                Picker("Flavor", selection: $selectedRange) {
                    ForEach(StatsViewModel.GraphPlotOptions.allCases) { option in
                            Text(option.rawValue.capitalized)
                        }
                    }
                .pickerStyle(.segmented)
                .padding()
            }
        }
    }
}

#Preview {
    let vm = StatsViewModel()
    
    StatTimeDedicatedSection(sessionActivities: vm.sampleData(for: .week),
                             selectedRange: .constant(StatsViewModel.GraphPlotOptions.week.rawValue))
}
