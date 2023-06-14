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
        
        case textForTrainers = "By choosing this app role you will be able to keep track of your clients, track their workouts and changes in their body parameters"
        
        case textForSelfTrain = "By choosing this role of the app you will be able to keep records only of your workouts, monitor changes in your body parameters only"
    }
    @Published  var openCustomerView = false
    @Published  var customAlert = false
    @Published  var textForAlert: InfoText = .textForTrainers
    
// MARK:  - Methods -
    
   
    
}
