//
//  WorkoutViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 15.06.23.
//

import Foundation
import Combine

final class WorkoutViewViewModel: ObservableObject {
    
    // MARK:  - Variables -
    
    @Published var exerciseListVM = ExercisesViewViewModel()
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    private var cancellable =  Set<AnyCancellable>()
    
    @Published var workout: [OneExersice] = []
    @Published var oneExerciseForWorkout: Exercise?
    @Published var clientData: Client

    
    @Published var repetitions = [""]
    @Published var weights = [""]
    @Published var currentDate = Date()
    @Published var workoutName: String = "New Workout" 
    @Published var workoutNameEdit = false
    @Published var isPresented = false
    @Published var endedExercises: [OneExersice] = []
    @Published var warningAlert = false
    @Published var warningText = ""
 
    
    enum WarningMessage {
        case emptySet
        case emptyExercise
        case emptyWorkoutName
        
        var text: String {
            switch self {
            case .emptyExercise:
                return "Exercise in workout must contain at least one set"
            case .emptySet:
                return "Fill reps and weight"
            case .emptyWorkoutName:
                return "Workout name cannot be empty"
            }
            
        }
    }
    
    
    // MARK:  - Methods -
 
    func addSet(exercise: OneExersice) {
        guard !exercise.newItem2.isEmpty, !exercise.newItem.isEmpty else {
            warningAlert = true
            warningText = WarningMessage.emptySet.text
            return
            
        }
        
        var updatedExercise = exercise
        updatedExercise.sets.append(OneSet(rep: updatedExercise.newItem, weight: updatedExercise.newItem2))
        workout = workout.filter { $0 != exercise }
        workout.append(updatedExercise)
    }
  
    func saveWorkout() {
        guard !workout.contains(where: { $0.sets.isEmpty}) else {
            warningAlert = true
            warningText = WarningMessage.emptyExercise.text
            return
            
        }
        Task { [weak self] in
            guard let self = self else {return}
            
            if Constants.currentState == .loggedAsSelf  {
                await self.fireBaseManager.saveCustomerWorkout(name: workoutName, date: currentDate, workout: workout)
            } else {
                await self.fireBaseManager.saveClientWorkout(name: workoutName, date: currentDate, workout: workout, clientID: clientData.id)
            }
            await MainActor.run {
                self.workout = []
                self.workoutName = "New Workout"
            }
        }

    }
    
    func exerciseNumberText(exercise: OneExersice ) -> String {
        guard let index =  workout.firstIndex(of: exercise) else { return "empty"}
            let value = index + 1
        return String("\(value).")
    }
    
    
    func setNumberText(set: OneSet, sets: [OneSet] ) -> String {
        guard let index = sets.firstIndex(of: set) else { return "empty"}
            let value = index + 1
        return String("Set \(value):")

    }
    
    func checkWorkoutName() {
        if workoutName.isEmpty {
            warningAlert = true
            warningText = WarningMessage.emptyWorkoutName.text
            workoutName = "New Workout"
        } else {
            workoutNameEdit.toggle()
        }
    }
    
    init(clientData: Client) {
        self.clientData = clientData

        
        exerciseListVM.$workoutExercise.compactMap { $0 }
            .sink { [weak self] item in
                guard let self = self else {return}
                workout = workout.filter { !$0.sets.isEmpty }
                self.endedExercises = self.workout
                self.oneExerciseForWorkout = item
                self.workout.append(OneExersice(name: "\(oneExerciseForWorkout?.name ?? "error")", sets: []))
            }
            
            .store(in: &cancellable)
    }
    
    
    deinit {
            cancellable.removeAll()
        }
    
}
