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
            
            Text("\(self.viewModel.getReadableTime(from: sessioninfo.timeCompleted)) / \(self.viewModel.getReadableTime(from: sessioninfo.timeAllotted))")
        }
    }
}

#Preview {
    let userTaskModel = UserTaskModel(taskName: "Test", type: .chores, timeAllotted: 40.0)
    DashboardSessionInfo(sessioninfo: userTaskModel, viewModel: DashboardViewModel())
}
