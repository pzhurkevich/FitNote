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
    // MARK:  - Methods -
 
    func addSet(exercise: OneExersice) {
        guard !exercise.newItem2.isEmpty, !exercise.newItem.isEmpty else { return }
        
        var updatedExercise = exercise
        updatedExercise.sets.append(OneSet(rep: updatedExercise.newItem, weight: updatedExercise.newItem2))
        workout = workout.filter { $0 != exercise }
        workout.append(updatedExercise)
    }
  
    func saveWorkout() {
        
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
    
    
    
    init(clientData: Client) {
        self.clientData = clientData

        
        exerciseListVM.$workoutExercise.compactMap { $0 }
            .sink { [weak self] item in
                guard let self = self else {return}
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
