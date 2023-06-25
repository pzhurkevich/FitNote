//
//  OneExercise.swift
//  FitNote
//
//  Created by Pavel on 23.06.23.
//

import Foundation

struct OneExersice: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var sets: [OneSet]
    var newItem = ""
    var newItem2 = ""
}
