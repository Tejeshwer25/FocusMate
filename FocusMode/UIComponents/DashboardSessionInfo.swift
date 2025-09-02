//
//  DashboardSessionInfo.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 30/08/25.
//

import SwiftUI

struct DashboardSessionInfo: View {
    @State var sessioninfo: UserTaskModel
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        HStack {
            Text(sessioninfo.type.getEmojiForType())
            Text(sessioninfo.taskName)
            
            Spacer()
            
            Text("\(self.getReadableTime(from: sessioninfo.timeCompleted)) / \(self.getReadableTime(from: sessioninfo.timeAlloted))")
        }
    }
    
    /// Method to get time string from session time property
    /// - Parameter seconds: time in float
    /// - Returns: time in representable format
    func getReadableTime(from seconds: CGFloat) -> String {
        let secondsDouble = Double(seconds)
        let time = self.viewModel.convertSecondsToRequiredTime(seconds: secondsDouble)
        let timeString = self.viewModel.getReadableStringFromTime(time: time)
        
        return timeString
    }
}

#Preview {
    let userTaskModel = UserTaskModel(taskName: "Test", type: .chores, timeAlloted: 40.0)
    DashboardSessionInfo(sessioninfo: userTaskModel, viewModel: DashboardViewModel())
}
