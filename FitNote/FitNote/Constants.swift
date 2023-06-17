//
//  Constants.swift
//  FitNote
//
//  Created by Pavel on 12.06.23.
//

import Foundation


struct Constants {
    static var imgDB = "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/"
    static var dbURL = "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json"
    

    
    enum State: String {
        case loggedAsTrainer = "trainer"
        case loggedAsSelf = "selfTrain"
        case notLogged = "notLogged"
       
    }
    
    static var currentState = State(rawValue: UserDefaults.standard.string(forKey: "appState") ?? "")
    
}
