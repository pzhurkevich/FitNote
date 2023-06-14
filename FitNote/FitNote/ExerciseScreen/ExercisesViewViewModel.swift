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
    
    @Published var searchText = ""
    @Published var tappedID: UUID?
   
    
    
// MARK:  - Methods -
    
    func fetchExercises() async {
        do {
           
              let data  =  try await self.apiProvider.getAllExercise()
          
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                
                self.exercises = data
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
    
}
