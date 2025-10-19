//
//  ContentView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 14/08/25.
//

import SwiftUI

struct CreateTaskView: View {
    @State private var focusTime    = ""
    @State private var showAlert    = false
    @State private var taskName     = ""
    @State private var taskType     = TaskType.chores
    @State private var alertType: AppErrors?
    @State private var userTask: UserTaskModel?
    @State private var navigateToFocus = false
    
    let viewModel = CreateTaskViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading) {
                    Text("Enter Task Name: ")
                    
                    TextField("Task Name", text: $taskName)
                        .padding()
                        .foregroundStyle(Color(uiColor: .label))
                        .textContentType(.birthdateYear)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(uiColor: .tertiarySystemFill))
                        }
                        .overlay {
                            if self.showAlert && self.alertType == .taskNameEmpty {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(uiColor: .systemRed), lineWidth: 1)
                            }
                        }
                    
                    if self.showAlert && self.alertType == .taskNameEmpty {
                        Text(self.alertType?.alertMessage ?? "Invalid task name")
                            .font(.callout)
                            .foregroundStyle(Color.red)
                    }
                }
                
                HStack(alignment: .center) {
                    Text("Select task type: ")
                    
                    Spacer()
                    
                    Picker("Task Type", selection: $taskType) {
                        ForEach(TaskType.allCases, id: \.self) { type in
                            Text(type.getTaskName() + " " + type.getEmojiForType())
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading) {
                    Text("Enter time for focus(in minutes): ")
                        .frame(alignment: .leading)
                    
                    TextField("Focus time", text: $focusTime)
                        .padding()
                        .foregroundStyle(Color(uiColor: .label))
                        .textContentType(.birthdateYear)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(uiColor: .tertiarySystemFill))
                        }
                        .overlay {
                            if self.showAlert &&
                                (self.alertType == .taskDurationEmpty
                                 || self.alertType == .taskDurationInvalid) {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(uiColor: .systemRed), lineWidth: 1)
                            }
                        }
                    
                    if self.showAlert &&
                        (self.alertType == .taskDurationEmpty
                         || self.alertType == .taskDurationInvalid) {
                        Text(self.alertType?.alertMessage ?? "Inavlid task duration")
                            .font(.callout)
                            .foregroundStyle(Color.red)
                    }
                }
                
                Button {
                    self.handleStartFocusMode(time: focusTime)
                } label: {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 50)
                        .padding()
                        .foregroundStyle(.black)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.green)
                        }
                }
                
                Spacer()
            }
            .padding(.top, 25)
            .padding(.horizontal)
            .navigationTitle("Create new task")
            .navigationDestination(isPresented: $navigateToFocus) {
                if let userTask {
                    FocusModeView(userTask: userTask)
                }
            }
        }
    }
    
    /// Method to handle tap on start button
    /// - Parameter time: Time user has entered
    func handleStartFocusMode(time: String) {
        withAnimation {
            self.showAlert = false
        }
        
        let userInputValidationState = self.viewModel.validateUserInputs(taskName: self.taskName, taskDuration: self.focusTime)
        
        if !userInputValidationState.status {
            self.alertType = userInputValidationState.alertType
            self.navigateToFocus = false
            
            withAnimation {
                self.showAlert = true
            }
            
            return
        }
        
        if let focusTime = Float(time) {
            let time = CGFloat(focusTime) * 60
            self.userTask = UserTaskModel(taskName: self.taskName,
                                          type: self.taskType,
                                          timeAllotted: time)
            
            if let userTask = self.userTask {
                self.userTask = userTask
                self.navigateToFocus = true
            }
        } else {
            self.showAlert.toggle()
            self.navigateToFocus = false
        }
    }
}

#Preview {
    CreateTaskView()
}
