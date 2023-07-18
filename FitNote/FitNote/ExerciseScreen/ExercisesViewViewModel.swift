//
//  ExercisesViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 12.06.23.
//

import Foundation


final class ExercisesViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    var apiProvider: ProviderProtocol = AlamofireProvider()
    
    @Published var exercises: [Exercise] = []
    @Published var exercisesTemp: [Exercise] = []
    @Published var expandedIDs: [UUID] = []
    @Published var workoutExercise: Exercise?
    @Published var exerciseCategories: [ExerciseCategory] = [
        ExerciseCategory(name: "ALL", img: "all"),
        ExerciseCategory(name: "Abs", img: "abdominals"),
        ExerciseCategory(name: "Back", img: "back"),
        ExerciseCategory(name: "Biceps", img: "biceps"),
        ExerciseCategory(name: "Calves", img: "calves"),
        ExerciseCategory(name: "Chest", img: "chest"),
        ExerciseCategory(name: "Forearm", img: "forearm"),
        ExerciseCategory(name: "Shoulders", img: "shoulder"),
        ExerciseCategory(name: "Neck", img: "neck"),
        ExerciseCategory(name: "Triceps", img: "triceps")
    ]
    
    var searchResults: [Exercise] {
       
        if searchText.isEmpty {
           
                    return exercises
                } else {
                    return exercises.filter { $0.name.contains(searchText) }
                }
    }
    
    @Published var searchText = ""
    @Published var currentMuscles = "All"
    @Published var tappedID: UUID?
   
    
// MARK:  - Methods -
    
    func fetchExercises() async {
        do {
           
              let data  =  try await self.apiProvider.getAllExercise()
          
            await MainActor.run {
                self.exercises = data
                self.exercisesTemp = data
            }
                
        } catch {
            print("error while fetching exercises")
        }
     
    }
    
    
    func imageURL(source: Exercise) -> URL? {
        guard let previewImage = source.images.first,
              let url = URL(string: "\(Constants.imgDB)\(previewImage)") else { return nil }
   
        return url
    }
    func secondImageURL(source: Exercise) -> URL? {
        guard let previewImage = source.images.last,
              let url = URL(string: "\(Constants.imgDB)\(previewImage)") else { return nil }
   
        return url
    }
    
    
    func addToWorkout(exercise: Exercise) {
        self.workoutExercise = exercise
    }
    
    func filterExercises(muscle: ExerciseCategory) {
        expandedIDs = []
        if muscle.img == "all" {
            exercises = exercisesTemp
        } else {
            exercises = exercisesTemp
            exercises = exercises.filter {$0.primaryMuscles.contains(where: { $0.rawValue.contains(muscle.img)})}
        }
        currentMuscles = muscle.name
    }
    
    func collapseRow(id: UUID) {
        if expandedIDs.contains(id) {
            expandedIDs = expandedIDs.filter { $0 != id }
        } else {
            expandedIDs.append(id)
        }
    }
    
}
