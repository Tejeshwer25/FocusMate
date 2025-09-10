//
//  StatsTaskBreakdownView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 10/09/25.
//

import SwiftUI

struct StatsTaskBreakdownView: View {
    let tasks: [StatsViewModel.TaskBreakdown]
    @State private var isExpanded = true
    @State private var selectedTask: TaskType? = .exercise
    
    var body: some View {
        Section("Previous Tasks") {
            ForEach(tasks) { task in
                Button {
                    withAnimation {
                        self.isExpanded.toggle()
                        self.selectedTask = task.taskType
                    }
                } label: {
                    HStack {
                        Text(task.taskType.getEmojiForType() + " " + task.taskType.getTaskName())
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Spacer()
                        
                        Image(systemName: self.selectedTask == task.taskType
                              && isExpanded
                              ? "arrowtriangle.up.fill"
                              : "arrowtriangle.down.fill")
                    }
                }
                .padding(.vertical, 8)
                
                if task.taskType == self.selectedTask && self.isExpanded {
                    getExpandedSection(task: task)
                }
            }
        }
    }
    
    func getExpandedSection(task: StatsViewModel.TaskBreakdown) -> some View {
        VStack(alignment: .leading) {
            ForEach(task.sessions) { session in
                HStack {
                    Text(session.title)
                    Spacer()
                    Text("\(session.completionPercent)%")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    let vm = StatsViewModel()
    let mock = vm.getTaskBreakdownData()
    StatsTaskBreakdownView(tasks: mock)
}
