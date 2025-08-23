//
//  ProgressView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 14/08/25.
//

import SwiftUI

struct ProgressView: View {
    @Binding var progress: CGFloat
    @Binding var timeRemaining: String
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 12)
            
            // Progress circle
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(
                    Color.green,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Start at top
                .animation(.easeInOut(duration: 0.2), value: progress)
            
            // Percentage text
            Text("\(timeRemaining)")
                .padding()
                .font(.title2)
                .bold()
        }
    }
}

#Preview {
    ProgressView(progress: .constant(0.1), timeRemaining: .constant("75m:4s"))
}
