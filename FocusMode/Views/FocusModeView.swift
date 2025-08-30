//
//  FocusModeView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 14/08/25.
//

import SwiftUI
import Combine
import AVFoundation
import CoreData

struct FocusModeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var context

    
    @State var userTask: UserTaskModel
    @State private var showOverlay = false
    @State private var progress: CGFloat = 0.0
    @State private var timeRemaining: CGFloat = 0.0 {
        didSet {
            self.timeRemainingString = self.getTimeRemainingString()
        }
    }
    @State private var timeRemainingString: String = ""
    @State private var timerConnection: Cancellable?
    @State private var sessionCancelled = false
    @State private var sessionCancellationAlert = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            Spacer()
            
            Text("Focus mode active")
                .font(.title)
            
            ProgressView(progress: $progress, timeRemaining: $timeRemainingString)
                .frame(width: 200, height: 200)
            
            Spacer()
            
            HStack {
                Image(systemName: "info.circle")
                Text("For accurate focus tracking, stay on this screen or lock your device. Time will not be tracked in the background.")
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.orange.opacity(0.2))
            }
            .padding(.horizontal, 20)
            
            Button {
                dismiss()
            } label: {
                Text("Abandon Task")
                    .font(.headline)
                    .padding(.horizontal, 25)
                    .padding()
                    .foregroundStyle(.red)
                    .background {
                        Capsule()
                            .foregroundStyle(Color(uiColor: .systemGray3).opacity(0.3))
                    }
            }
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if self.showOverlay {
                ZStack {
                    Color(uiColor: .secondarySystemBackground)
                        .opacity(0.75)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 25) {
                        Image(systemName: "bell.and.waves.left.and.right.fill")
                            .font(.system(size: 50))
                            .symbolEffect(.wiggle)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color(uiColor: .label), .red)
                            .frame(width: 50, height: 50)
                        Text("Timer Up")
                        Button {
                            self.saveFocusSessionToCoreData()
                            dismiss()
                        } label: {
                            Text("Go to Home")
                        }
                        .padding(.top)
                    }
                    .padding(50)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(uiColor: .systemBackground))
                            .shadow(color: Color(uiColor: .systemGray3), radius: 2)
                    }
                }
            }
        }
        .alert("Session Cancelled", isPresented: $sessionCancellationAlert) {
                    Button("OK", role: .cancel) {
                        dismiss()
                    }
        } message: {
            Text("Your focus session was cancelled because the app was moved to background.")
        }
        .onAppear {
            self.initializeTimeRemaining()
            self.timerConnection = self.timer.connect()
        }
        .onDisappear {
            self.timerConnection?.cancel()
        }
        .onReceive(timer) { _ in
            self.updateProgress()
        }
        .onChange(of: self.scenePhase, { oldValue, newPhase in
            if newPhase == .background {
                let isUnlocked = UIApplication.shared.isProtectedDataAvailable
                if isUnlocked {
                    sessionCancelled = true
                    timerConnection?.cancel()
                }
            }
            if newPhase == .active && sessionCancelled {
                sessionCancellationAlert = true
            }
        })
        .toolbarVisibility(.hidden, for: .navigationBar)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
    
    /// Method to initialize state on view appearance
    func initializeTimeRemaining() {
        self.timeRemaining = self.userTask.timeAlloted
    }
    
    /// Method to update timer on each second
    func updateProgress() {
        let timeAlloted   = self.userTask.timeAlloted
        
        self.timeRemaining -= 1
        if self.timeRemaining >= 0 {
            let progress = (timeAlloted - self.timeRemaining) / timeAlloted
            self.progress = progress
        } else {
            self.showOverlay = true
            self.userTask.timeCompleted = self.userTask.timeAlloted
            AudioServicesPlayAlertSound(SystemSoundID(1004))
        }
    }
    
    /// Method to get time remaining in `mm:ss` format
    /// - Returns: time remaining in string `mm:ss` format
    func getTimeRemainingString() -> String {
        let seconds = self.timeRemaining
        let minutes = seconds / 60
        let remainingSeconds = seconds.truncatingRemainder(dividingBy: 60)
        return String(format: "%.0fm:%.0fs", floor(minutes), remainingSeconds)
    }
    
    /// Method to save current session to core data
    func saveFocusSessionToCoreData() {
        var task: TaskEntity?
        let taskRequest = TaskEntity.fetchRequest() as NSFetchRequest<TaskEntity>
        let requestPredicate = NSPredicate(format: "type == %@", self.userTask.type.rawValue)
        taskRequest.predicate = requestPredicate
        
        do {
            let task = try context.fetch(taskRequest).first
        } catch {}
        
        if task == nil {
            task = TaskEntity(context: self.context)
            task?.id = UUID()
            task?.type = self.userTask.type.rawValue
            task?.createdAt = Date()
        }
        
        let session = FocusSessionEntity(context: self.context)
        session.id = UUID()
        session.name = self.userTask.taskName
        session.durationAlloted = self.userTask.timeAlloted
        session.durationCompleted = self.userTask.timeCompleted
        session.startTime = Date()
        session.endTime = Date()
        session.focusScore = 0
        
        task?.addToSessions(session)
        
        do {
            try self.context.save()
        } catch {
            print("Error while saving focus session \(error.localizedDescription)")
        }
    }
}

#Preview {
    let userTask = UserTaskModel(taskName: "", type: .chores, timeAlloted: 1000)
    FocusModeView(userTask: userTask)
}
