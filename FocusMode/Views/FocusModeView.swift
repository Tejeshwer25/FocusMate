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
    @EnvironmentObject private var notificationManager: NotificationManager

    @State var userTask: UserTaskModel
    @StateObject private var viewModel: FocusModeViewModel
    
    @State private var timerConnection: Cancellable?
    @State private var sessionCancelled = false
    @State private var sessionCancellationAlert = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
    
    init(userTask: UserTaskModel) {
        _userTask = State(initialValue: userTask)
        _viewModel = StateObject(wrappedValue: FocusModeViewModel(userTask: userTask))
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            Spacer()
            
            Text("Focus mode active")
                .font(.title)
            
            ProgressView(progress: $viewModel.progress, timeRemaining: $viewModel.timeRemainingString)
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
                self.viewModel.saveFocusSessionToCoreData(context: self.context)
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
            if self.viewModel.showOverlay {
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
                            self.viewModel.saveFocusSessionToCoreData(context: self.context)
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
                        self.viewModel.saveFocusSessionToCoreData(context: self.context)
                        dismiss()
                    }
        } message: {
            Text("Your focus session was cancelled because the app was moved to background.")
        }
        .onAppear {
            self.viewModel.initializeTimeRemaining()
            self.timerConnection = self.timer.connect()
        }
        .onDisappear {
            self.timerConnection?.cancel()
        }
        .onReceive(timer) { _ in
            self.viewModel.updateProgress()
        }
        .onChange(of: self.scenePhase, { oldValue, newPhase in
            if newPhase == .background {
                Task {
                    do {
                        try await self.notificationManager.sendUserNotifications(identifier: "sessionProgressAppInactive",
                                                                             title: "Focus Session in Progress",
                                                                             message: "Your focus session is still active. Please return to the Focus screen within 5 minutes to continue. If the app remains inactive or is closed, the session will be cancelled.")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        })
        .toolbarVisibility(.hidden, for: .navigationBar)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}

#Preview {
    let userTask = UserTaskModel(taskName: "", type: .chores, timeAllotted: 10000)
    FocusModeView(userTask: userTask)
}
