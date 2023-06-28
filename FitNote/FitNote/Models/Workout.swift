//
//  Workout.swift
//  FitNote
//
//  Created by Pavel on 29.06.23.
//

import Foundation

struct Workout: Identifiable, Equatable {
    let id = UUID()
    var nameWorkout: String
    var dateWorkout: Date
    var allExercises: [OneExersice]
   
}
