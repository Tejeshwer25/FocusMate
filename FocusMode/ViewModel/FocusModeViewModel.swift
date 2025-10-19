//
//  FocusModeViewModel.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 19/08/25.
//

import Foundation
import Combine
import CoreData
import AudioToolbox

class FocusModeViewModel: ObservableObject {
    var userTask: UserTaskModel
    
    @Published var progress: CGFloat = 0.0
    @Published var timeRemainingString = ""
    @Published var showOverlay = false
    @Published var timeRemaining: CGFloat = 0.0 {
        didSet {
            self.timeRemainingString = self.getTimeRemainingString()
        }
    }
    
    init(userTask: UserTaskModel) {
        self.userTask = userTask
    }
    
    /// Method to initialize state on view appearance
    func initializeTimeRemaining() {
        self.timeRemaining = self.userTask.timeAllotted
    }
    
    /// Method to update timer on each second
    func updateProgress() {
        let timeAllotted   = self.userTask.timeAllotted
        
        self.timeRemaining -= 1
        if self.timeRemaining >= 0 {
            let progress = (timeAllotted - self.timeRemaining) / timeAllotted
            self.userTask.timeCompleted = timeAllotted - self.timeRemaining
            self.progress = progress
        } else {
            self.showOverlay = true
            self.userTask.timeCompleted = self.userTask.timeAllotted
            AudioServicesPlayAlertSound(SystemSoundID(1004))
        }
    }
    
    
    /// Method to save current session to core data
    func saveFocusSessionToCoreData(context: NSManagedObjectContext) {
        var task: TaskEntity?
        let taskRequest = TaskEntity.fetchRequest() as NSFetchRequest<TaskEntity>
        let requestPredicate = NSPredicate(format: "type == %@", self.userTask.type.rawValue)
        taskRequest.predicate = requestPredicate
        
        do {
            task = try context.fetch(taskRequest).first
        } catch {}
        
        if task == nil {
            task = TaskEntity(context: context)
            task?.id = UUID()
            task?.type = self.userTask.type.rawValue
            task?.createdAt = Date()
        }
        
        let session = FocusSessionEntity(context: context)
        session.id = UUID()
        session.name = self.userTask.taskName
        session.durationAllotted = self.userTask.timeAllotted
        session.durationCompleted = self.userTask.timeCompleted
        session.startTime = Date()
        session.endTime = Date()
        session.focusScore = self.userTask.timeCompleted / self.userTask.timeAllotted
        
        task?.addToSessions(session)
        
        do {
            try context.save()
        } catch {
            print("Error while saving focus session \(error.localizedDescription)")
        }
    }
    
    /// Method to get time remaining in `mm:ss` format
    /// - Returns: time remaining in string `mm:ss` format
    private func getTimeRemainingString() -> String {
        let seconds = self.timeRemaining
        let minutes = seconds / 60
        let remainingSeconds = seconds.truncatingRemainder(dividingBy: 60)
        return String(format: "%.0fm:%.0fs", floor(minutes), remainingSeconds)
    }
}
