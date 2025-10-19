//
//  DashboardView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 17/08/25.
//

import SwiftUI

struct DashboardView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FocusSessionEntity.startTime, ascending: false)],
        animation: .default
    ) private var latestTasks: FetchedResults<FocusSessionEntity>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FocusSessionEntity.startTime, ascending: false)],
        predicate: NSPredicate(
            format: "startTime >= %@ AND startTime < %@",
            Calendar.current.startOfDay(for: Date()) as NSDate,
            Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!) as NSDate
        ),
        animation: .default
    ) private var todaysTasks: FetchedResults<FocusSessionEntity>
    
    let viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    headerView
                        .listRowInsets(EdgeInsets())
                }
                
                Section {
                    if latestTasks.isEmpty {
                        Text("No focus session created yet.")
                            .font(.headline)
                            .fontDesign(.serif)
                    } else {
                        ForEach(latestTasks.prefix(5)) { task in
                            DashboardSessionInfo(
                                sessioninfo: self.viewModel.getUserSessionInfo(from: task),
                                viewModel: self.viewModel)
                        }
                    }
                } header: {
                    HStack {
                        Text("Task History :")
                        
                        Spacer()
                        
                        if latestTasks.count > 5 {
                            Button {
                            } label: {
                                Text("View all")
                            }
                            .textCase(.lowercase)
                        }
                    }
                }
                
                Section("Today's Motivation: ") {
                    Text("The ability to concentrate and to use time well is everything.")
                        .font(.title3)
                        .fontDesign(.serif)
                        .italic()
                        .padding()
                        .padding(.bottom)
                }
                .padding(.top)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("FocusMate")
        }
    }
    
    var headerView: some View {
        VStack {
            HStack {
                VStack {
                    Text("\(self.viewModel.getTimeStringForUI(from: self.todaysTasks))")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Time spent today")
                }
                
                Spacer()
                
                VStack {
                    Text("\(todaysTasks.count)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Tasks created today")
                }
            }
            .padding()
            .padding(.top)
            
            NavigationLink {
                CreateTaskView()
            } label: {
                Text("Create New Task")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.black)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.green)
                    )
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            LinearGradient(colors: [.blue, .purple],
                           startPoint: .leading,
                           endPoint: .trailing)
            .opacity(0.8)
        }
    }
}

#Preview {
    DashboardView()
}
