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
    
    @Published var workout: [Exercise] = []

    
    private var cancellable =  Set<AnyCancellable>()
    
    @Published var repetitions: String = ""
    @Published var weight: String = ""
    
    
    // MARK:  - Methods -
 
    
  
    
    init() {
        
        exerciseListVM.$workoutExercises
           
            .sink { [weak self] item in
                guard let self = self else {return}
                self.workout = item
               
                
            }
            .store(in: &cancellable)
    }
    
    
    deinit {
            cancellable.removeAll()
        }
    
}
