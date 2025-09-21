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
                .padding()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 5, bottom: 8, trailing: 5))
                .listRowBackground(Color.clear)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .shadow(color: Color(uiColor: .tertiaryLabel), radius: 3)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                }
                
                if task.taskType == self.selectedTask && self.isExpanded {
                    getExpandedSection(task: task)
                        .listRowInsets(EdgeInsets(top: 8, leading: 5, bottom: 8, trailing: 5))
                        .listRowBackground(Color.clear)
                }
            }
        }
    }
    
    func getExpandedSection(task: StatsViewModel.TaskBreakdown) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Session Name")
                Spacer()
                Text("Completion Percent")
            }
            .foregroundStyle(Color(uiColor: .secondaryLabel))
            .font(.footnote)
            .padding(.horizontal)
            
            Divider()
                .padding(.bottom)
            
            ForEach(task.sessions) { session in
                HStack {
                    Text(session.title)
                    Spacer()
                    Text("\(session.completionPercent, specifier: "%.2f")%")
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    let vm = StatsViewModel()
    let mock = vm.getGroupedSessions(from: [])
    StatsTaskBreakdownView(tasks: mock)
}
