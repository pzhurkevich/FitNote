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
    //@Published var appUserData: AppUser
    
    @Published var repetitions = [""]
    @Published var weights = [""]
    @Published var currentDate = Date()
    @Published var workoutName: String = "New Workout"
    @Published var workoutNameEdit = false
    @Published var isPresented = false
    
    // MARK:  - Methods -
 
    func addSet(exercise: inout OneExersice) {
        guard !exercise.newItem2.isEmpty, !exercise.newItem.isEmpty else { return }
        exercise.sets.append(OneSet(rep: exercise.newItem, ves: exercise.newItem2))
    }
  
    func saveWorkout() {
        
        Task { [weak self] in
            guard let self = self else {return}
            
            guard let data  =  try await self.fireBaseManager.fetchAppUser() else { return }
            
            if data.appRole == "selfTrain" {
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
    
//    func getWorkouts() async {
//        let workoutsFromServer  =  await self.fireBaseManager.fetchClientsWorkouts(clientID: clientData.id)
//      
//        await MainActor.run {
//            if let testWorkout = workoutsFromServer.first {
//                self.workout = testWorkout.allExercises
//            }
//            
//            
//        }
//    }
//    
    
    
    init(clientData: Client) {
        self.clientData = clientData

        
        exerciseListVM.$workoutExercise
            .sink { [weak self] item in
                guard let self = self else {return}
                self.oneExerciseForWorkout = item
                
                if oneExerciseForWorkout != nil {
                    self.workout.append(OneExersice(name: "\(oneExerciseForWorkout?.name ?? "error")", sets: []))
                }
            }
            
            .store(in: &cancellable)
    }
    
    
    deinit {
            cancellable.removeAll()
        }
    
}
