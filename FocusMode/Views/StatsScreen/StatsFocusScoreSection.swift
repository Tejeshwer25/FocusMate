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
                    Spacer(minLength: 10) // 👈 Push chevron away
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

            
            Chart(self.getDataBasedOnSelection()) {
                LineMark(x: .value("Time", $0.date),
                         y: .value("Focus Score", $0.score))
                
                if let selectedDate  {
                    RuleMark(x: .value("Selected Date", selectedDate, unit: .day))
                        .foregroundStyle(Color.appTextSecondary.opacity(0.4))
                        .zIndex(-1)
                        .offset(y: -50)
                        .annotation(position: .bottom,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit, y: .disabled)) {
                            popoverView
                                .zIndex(10)
                        }
                }
            }
            .chartXSelection(value: $selectedDateOnChart)
            .frame(height: 300)
            .padding()
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
        .background(Color.appCard)
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
            return self.taskFocusScore.filter { $0.taskName == self.selectedTask }
        } else {
            return self.taskFocusScore
        }
    }
}

#Preview {
    let vm = StatsViewModel()
    let mock = vm.generateFocusScoreMockData()
    StatsFocusScoreSection(taskFocusScore: mock)
}
