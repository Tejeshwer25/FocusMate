//
//  DashboardView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 17/08/25.
//

import SwiftUI

struct DashboardView: View {
    let tasks: [UserTaskModel] = [
        .init(taskName: "Swimming", type: .exercise, timeAlloted: 10),
        .init(taskName: "Dancing", type: .creative, timeAlloted: 30)
    ]
    @State private var path = [NavigationLinkType]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    headerView
                        .listRowInsets(EdgeInsets())
                }
                
                Section {
                    ForEach(tasks) { task in
                        HStack {
                            Text("🏋️‍♂️")
                            Text(task.taskName)
                            
                            Spacer()
                            
                            Text(String(format: "%.2f", Double(task.timeCompleted)))
                            Text("/")
                            Text(String(format: "%.2f", Double(task.timeAlloted)))
                        }
                    }
                } header: {
                    HStack {
                        Text("Task History :")
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("View all")
                        }
                        .textCase(.lowercase)
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
            .navigationDestination(for: NavigationLinkType.self) { value in
                switch value {
                case .creteTask:
                    CreateTaskView(navPath: $path)
                case .focusMode(let userTaskModel):
                    FocusModeView(userTask: userTaskModel)
                }
            }
        }
    }
    
    var headerView: some View {
        VStack {
            HStack {
                VStack {
                    Text("1h0m")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Time spent today")
                }
                
                Spacer()
                
                VStack {
                    Text("3")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Tasks created today")
                }
            }
            .padding()
            .padding(.top)
            
            Button {
                self.path.append(NavigationLinkType.creteTask)
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
            .frame(maxWidth: .infinity)
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
