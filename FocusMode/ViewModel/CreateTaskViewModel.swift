//
//  CreateTaskViewModel.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 11/10/25.
//

import Foundation

class CreateTaskViewModel: ObservableObject {
    /// Method to validate user input
    /// - Returns: Has user entered correct input
    func validateUserInputs(taskName: String, taskDuration: String) -> (status: Bool, alertType: AppErrors?) {
        if !taskName.isEmpty {
            if !taskDuration.isEmpty {
                if let duration = Float(taskDuration), duration > 0 {
                    return (true, nil)
                } else {
                    return (false, .taskDurationInvalid)
                }
            } else {
                return (false, .taskDurationEmpty)
            }
        } else {
            return (false, .taskNameEmpty)
        }
    }
}
