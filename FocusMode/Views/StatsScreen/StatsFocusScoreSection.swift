//
//  StatsFocusScoreSection.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 10/09/25.
//

import SwiftUI
import Charts

struct StatsFocusScoreSection: View {
    @State private var selectedTask = "all"
    @State private var selectedDateOnChart: Date?
    
    private var selectedDate: Date? {
        self.selectedDateOnChart
    }
    let taskFocusScore: [StatsViewModel.FocusScoreMockData]
    
    var body: some View {
        Section("Focus Score") {
            Menu {
                Button("All Tasks") {
                    selectedTask = "all"
                }
                ForEach(TaskType.allCases, id: \.self) { task in
                    Button(task.getEmojiForType() + " " + task.getTaskName()) {
                        selectedTask = task.rawValue
                    }
                }
            } label: {
                HStack {
                    Text(self.getSelectedMenuText())
                    Spacer(minLength: 10)
                    Image(systemName: "chevron.down")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(uiColor: .tertiaryLabel))
                }
            }
            .foregroundStyle(Color(uiColor: .label))
            .padding(.vertical)
            
            if self.getDataBasedOnSelection().count > 1 {
                Chart(self.getDataBasedOnSelection()) {
                    LineMark(x: .value("Time", $0.date),
                             y: .value("Focus Score", $0.score))
                    
                    if let selectedDate {
                        RuleMark(x: .value("Selected", selectedDate, unit: .day)) .lineStyle(StrokeStyle(lineWidth: 2, dash: [4]))
                            .foregroundStyle(Color.appTextSecondary)
                            .offset(yStart: 0)
                            .zIndex(-1)
                            .annotation(position: .bottom,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart),
                                                                  y: .fit)) {
                                popoverView
                            }
                    }
                }
                .chartXSelection(value: $selectedDateOnChart)
                .frame(height: 300)
                .padding()
            } else {
                HStack {
                    Spacer()
                    Text("Not enough data to predict focus score")
                        .font(AppFonts.normalText.font)
                        .frame(height: 300)
                    Spacer()
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
                Text("Focus Score: ")
                Spacer()
                Text("\(self.getFocusScoreForDate(date: selectedDate ?? Date()))")
            }
        }
        .padding()
        .background(Color.appBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.appTextSecondary)
        }
    }
    
    func getSelectedMenuText() -> String {
        let taskSelected = TaskType(rawValue: self.selectedTask)
        
        switch taskSelected {
        case .none:
            return "All Tasks"
        case .some(let task):
            return task.getEmojiForType() + " " + task.getTaskName()
        }
    }
    
    func getDataBasedOnSelection() -> [StatsViewModel.FocusScoreMockData] {
        if TaskType(rawValue: self.selectedTask) != nil {
            let data = self.taskFocusScore.filter { $0.taskName == self.selectedTask }
            return data
        } else {
            return self.taskFocusScore
        }
    }
    
    /// Method to get focus score for selected date on chart
    /// - Parameter date: Date selected on chart
    /// - Returns: Focus score for the specified date
    func getFocusScoreForDate(date: Date) -> Double {
        for session in self.taskFocusScore {
            if Calendar.current.isDate(session.date, inSameDayAs: date) {
                return session.score
            }
        }
        
        return 0
    }
}

#Preview {
    let vm = StatsViewModel()
    let mock = vm.getFocusScorePerDayData(from: [])
    StatsFocusScoreSection(taskFocusScore: mock)
}
