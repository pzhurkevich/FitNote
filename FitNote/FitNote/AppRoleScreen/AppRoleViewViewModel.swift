//
//  AppRoleViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import Foundation

final class AppRoleViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    enum RoleSwitch: Identifiable {
        case trainer, customer
        var id: Int {
               switch self {
               case .trainer:
                   return 0
               case .customer:
                   return 1
               }
           }

    }
  
    
    enum InfoText: String {
        
        case textForTrainers = "By choosing this app role you will be able to log your clients in planner, track their workouts and changes in their body parameters"
        
        case textForSelfTrain = "By choosing this role of the app you will be able to keep logs only for your workouts, monitor changes in your body parameters only"
    }
    @Published var roleScreen: RoleSwitch?
    @Published  var customAlert = false
    @Published  var textForAlert: InfoText = .textForTrainers
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
// MARK:  - Methods -
    
   
    
    func updateRoleForUser(role: Constants.State) {
        fireBaseManager.updateUserRole(role: role.rawValue)
    }
}
