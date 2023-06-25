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
    private var cancellable =  Set<AnyCancellable>()
    
    @Published var workout1: [OneExersice] = []
    
    
    @Published var oneExerciseForWorkout: Exercise?
    
    @Published var repetitions = [""]
    @Published var weights = [""]
    @Published var currentDate = Date().formatted(date: .complete, time: .omitted)
    @Published var isPresented = false
    
    // MARK:  - Methods -
 
    func addSet(exercise: inout OneExersice) {
        guard !exercise.newItem2.isEmpty, !exercise.newItem.isEmpty else { return }
        exercise.sets.append(OneSet(rep: exercise.newItem, ves: exercise.newItem2))
//        exercise.newItem = ""
//        exercise.newItem2 = ""
       
    }
  
    
    init() {
        
        exerciseListVM.$workoutExercise
            .sink { [weak self] item in
                guard let self = self else {return}
                self.oneExerciseForWorkout = item
                
                if oneExerciseForWorkout != nil {
                    self.workout1.append(OneExersice(name: "\(oneExerciseForWorkout?.name ?? "error")", sets: []))
                }
            }
            
            .store(in: &cancellable)
    }
    
    
    deinit {
            cancellable.removeAll()
        }
    
}
