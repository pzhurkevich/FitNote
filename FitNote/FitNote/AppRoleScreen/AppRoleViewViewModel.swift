//
//  AppRoleViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import Foundation

final class AppRoleViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    

    enum InfoText: String {
        
        case textForTrainers = "By choosing this app role you will be able to log your clients in planner, track their workouts and changes in their body parameters"
        
        case textForSelfTrain = "By choosing this role of the app you will be able to keep logs only for your workouts, monitor changes in your body parameters only"
    }
    @Published  var customAlert = false
    @Published  var showMainTab = false
    @Published  var textForAlert: InfoText = .textForTrainers
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
// MARK:  - Methods -
    
    func trainerInfo() {
        customAlert.toggle()
        textForAlert = .textForSelfTrain
    }
    func selfTrainInfo() {
        customAlert.toggle()
        textForAlert = .textForTrainers
    }
    
    func updateRoleForUser(role: Constants.State) {
        Constants.currentState = role
        fireBaseManager.updateUserRole(role: role.rawValue)
        showMainTab.toggle()
    }
}
