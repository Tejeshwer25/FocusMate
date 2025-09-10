//
//  StatsFocusScoreSection.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 10/09/25.
//

import SwiftUI
import Charts

struct StatsFocusScoreSection: View {
    let taskFocusScore: [StatsViewModel.FocusScoreMockData]
    @State private var selectedTask = "all"
    
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
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(uiColor: .tertiarySystemBackground))
                )
            }
            .padding(.vertical)

            
            Chart(self.getDataBasedOnSelection()) {
                LineMark(x: .value("Time", $0.date),
                         y: .value("Focus Score", $0.score))
            }
            .frame(height: 300)
            .padding()
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
        if let taskSelected = TaskType(rawValue: self.selectedTask) {
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

//Picker("Selected Task", selection: $selectedTask) {
//    Text("All Tasks").tag("all")
//    ForEach(TaskType.allCases, id: \.self) { task in
//        Text(task.getEmojiForType() + " " + task.getTaskName())
//            .tag(task.rawValue)
//    }
//}
//.pickerStyle(.menu)
//.labelsHidden()
//.frame(maxWidth: .infinity, alignment: .leading)
//.padding()
//.background(Color(uiColor: .tertiarySystemBackground))
//.clipShape(RoundedRectangle(cornerRadius: 10))
//.padding(.vertical)
