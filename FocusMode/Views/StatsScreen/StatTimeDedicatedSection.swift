//
//  StatTimeDedicatedSection.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import SwiftUI
import Charts

struct StatTimeDedicatedSection: View {
    @Binding var selectedRange: String
    @State private var chartSelectedDate: Date?
    private var selectedDate: Date? {
        return chartSelectedDate
    }
    
    let sessionActivities: [StatsViewModel.GraphMockData]
    
    var body: some View {
        Section("Time Dedicated") {
            VStack {
                Picker("Flavor", selection: $selectedRange) {
                    ForEach(StatsViewModel.GraphPlotOptions.allCases) { option in
                            Text(option.rawValue.capitalized)
                        }
                    }
                .pickerStyle(.segmented)
                .padding()
                
                Spacer(minLength: 25)
                
                Chart {
                    ForEach(sessionActivities) { session in
                        BarMark(
                            x: .value("Date", session.date, unit: .day),
                            y: .value("Total Count", session.time)
                        )
                    }
                    
                    if let selectedDate {
                        RuleMark(x: .value("Selected", selectedDate, unit: .day))
                            .foregroundStyle(Color.appTextSecondary.opacity(0.2))
                            .offset(yStart: 0)
                            .zIndex(-1)
                            .annotation(position: .top,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart),
                                                                  y: .disabled)) {
                                popoverView
                            }
                    }
                }
                .chartXSelection(value: $chartSelectedDate)
                .frame(height: 300)
                .padding()
            }
        }
    }
    
    var popoverView: some View {
        VStack {
            HStack {
                Text("Date: ")
                Spacer()
                Text(selectedDate ?? Date(), format: .dateTime.day().month())
            }
            
            HStack {
                Text("Time: ")
                Spacer()
                Text("8hrs")
            }
        }
        .padding()
        .background(Color.appBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.appTextSecondary)
        }
    }
}

#Preview {
    let vm = StatsViewModel()
    
    StatTimeDedicatedSection(selectedRange: .constant(StatsViewModel.GraphPlotOptions.week.rawValue), sessionActivities: vm.sampleData(for: .week))
}
