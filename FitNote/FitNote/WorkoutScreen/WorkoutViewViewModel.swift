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
    
    @Published var workout: [Exercise] = []
    
    @Published var repetitions = [""]
    @Published var weights = [""]
    @Published var currentDate = Date().formatted(date: .complete, time: .omitted)
    @Published var isPresented = false
    
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
