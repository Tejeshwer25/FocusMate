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
    func initializeTimeRemaining(timeRemaining: CGFloat? = nil) {
        if let timeRemaining {
            self.timeRemaining = timeRemaining
        } else {
            self.timeRemaining = self.userTask.timeAllotted
        }
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
    func saveFocusSessionToCoreData(context: NSManagedObjectContext, finalize: Bool = false) {
        do {
            // Fetch task
            let taskRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            taskRequest.predicate = NSPredicate(format: "type == %@", self.userTask.type.rawValue)
            let task = try context.fetch(taskRequest).first ?? {
                let newTask = TaskEntity(context: context)
                newTask.id = UUID()
                newTask.type = self.userTask.type.rawValue
                newTask.createdAt = Date()
                return newTask
            }()
            
            // Fetch session
            let sessionRequest: NSFetchRequest<FocusSessionEntity> = FocusSessionEntity.fetchRequest()
            sessionRequest.predicate = NSPredicate(format: "id == %@", self.userTask.id as CVarArg)
            let sessionToSave = try context.fetch(sessionRequest).first ?? FocusSessionEntity(context: context)
            
            // Update properties
            sessionToSave.id = self.userTask.id
            sessionToSave.name = self.userTask.taskName
            sessionToSave.durationAllotted = self.userTask.timeAllotted
            sessionToSave.durationCompleted = self.userTask.timeCompleted
            
            if sessionToSave.startTime == nil {
                sessionToSave.startTime = Date()
            }
            if finalize {
                sessionToSave.endTime = Date()
            }
            
            if sessionToSave.task == nil {
                task.addToSessions(sessionToSave)
            }
            
            sessionToSave.focusScore = self.userTask.timeAllotted > 0 ? (self.userTask.timeCompleted / self.userTask.timeAllotted) : 0
            
            // Save context
            try context.save()
            print("Saved/updated session info")
        } catch {
            print("Error while saving focus session: \(error.localizedDescription)")
        }
    }
    
    /// Finalize and save the focus session (used when user abandons or completes)
    func finalizeAndSaveSession(context: NSManagedObjectContext) {
        self.saveFocusSessionToCoreData(context: context, finalize: true)
    }
    
    /// Method to get time remaining in `mm:ss` format
    /// - Returns: time remaining in string `mm:ss` format
    private func getTimeRemainingString() -> String {
        let seconds = self.timeRemaining
        let minutes = seconds / 60
        let remainingSeconds = seconds.truncatingRemainder(dividingBy: 60)
        return String(format: "%.0fm:%.0fs", floor(minutes), remainingSeconds)
    }
    
    /// Method to get uncompleted saved session if user resumes the app in specified time range
    /// - Parameters:
    ///   - id: session id
    ///   - context: core data context
    /// - Returns: Task to be resumed
    func getSavedUncompletedSavedSession(for id: UUID, context: NSManagedObjectContext) throws -> UserTaskModel? {
        let fetchRequest = FocusSessionEntity.fetchRequest() as NSFetchRequest<FocusSessionEntity>
        // Assuming FocusSessionEntity.id is UUID
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        // fetchRequest.fetchLimit = 1

        do {
            guard let result = try context.fetch(fetchRequest).first else {
                return nil
            }

            guard let sessionID = result.id,
                  let name = result.name
            else {
                return nil
            }

            // Safely derive type; default to .chores if relationship or type is missing
            let derivedType = TaskType(rawValue: result.task?.type ?? TaskType.chores.rawValue) ?? .chores

            let userTaskModel = UserTaskModel(
                id: sessionID,
                taskName: name,
                type: derivedType,
                timeAllotted: result.durationAllotted,
                timeCompleted: result.durationCompleted,
                wasCompleted: false
            )
            return userTaskModel
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

