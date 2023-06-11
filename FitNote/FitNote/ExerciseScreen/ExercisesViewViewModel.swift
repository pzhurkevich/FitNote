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
    
    var searchResults: [Exercise] {
        if searchText.isEmpty {
                    return exercises
                } else {
                    return exercises.filter { $0.name.contains(searchText) }
                }
    }
    
    @Published var exercise: Exercise?
    @Published var searchText = ""
    
    
// MARK:  - Methods -
    @MainActor
    func fetchExercises() {
        Task { [weak self] in
            guard let self = self else { return }
          
                self.exercises  =  try await  self.apiProvider.getAllExercise()
           
        }
     
    }
    
}
