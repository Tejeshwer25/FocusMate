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
    private var timeAlloted: Int? {
        let session = sessionActivities.first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate ?? Date())})
        return Int(session?.allotedTIme ?? 0)
    }
    private var timeCompleted: Int? {
        let session = sessionActivities.first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate ?? Date())})
        return Int(session?.completedTime ?? 0)
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
                
                if self.sessionActivities.isEmpty {
                    Text("No session available for this time period")
                        .font(AppFonts.normalText.font)
                        .frame(height: 300)
                } else {
                    Chart {
                        ForEach(sessionActivities) { session in
                            BarMark(
                                x: .value("Date", session.date, unit: .day),
                                y: .value("Hours", session.allotedTIme),
                                stacking: .unstacked
                            )
                            .foregroundStyle(.blue)
                            
                            BarMark(
                                x: .value("Date", session.date, unit: .day),
                                y: .value("Hours", session.completedTime),
                                stacking: .unstacked
                            )
                            .foregroundStyle(.green)
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
    }
    
    var popoverView: some View {
        VStack {
            HStack {
                Text("Date: ")
                Spacer()
                Text(selectedDate ?? Date(), format: .dateTime.day().month())
            }
            
            HStack {
                Text("Time Alloted: ")
                Spacer()
                Text("\(timeAlloted ?? -1) hrs")
            }
            
            HStack {
                Text("Time Completed: ")
                Spacer()
                Text("\(timeCompleted ?? -1) hrs")
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
    
    StatTimeDedicatedSection(selectedRange: .constant(StatsViewModel.GraphPlotOptions.week.rawValue),
                             sessionActivities: vm.getTimeFocused(for: .week, from: []))
}
