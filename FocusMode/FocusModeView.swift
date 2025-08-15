//
//  FocusModeView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 14/08/25.
//

import SwiftUI
import AVFoundation

struct FocusModeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var userTask: UserTaskModel
    @State private var showOverlay = false
    @State private var progress: CGFloat = 0.0
    @State private var timeRemaining: CGFloat = 0.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            Spacer()
            
            Text("Focus mode active")
                .font(.title)
            
            ProgressView(progress: $progress)
                .frame(width: 150, height: 150)
            
            Spacer()
            
            
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
        .onAppear {
            self.initializeTimeRemaining()
        }
        .onReceive(timer) { _ in
            self.updateProgress()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
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
}

#Preview {
    let userTask = UserTaskModel(taskName: "", type: .chores, timeAlloted: 400)
    FocusModeView(userTask: userTask)
}
