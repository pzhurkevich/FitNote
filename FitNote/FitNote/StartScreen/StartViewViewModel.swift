//
//  StartViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import Foundation
import SwiftUI


final class StartViewViewModel: ObservableObject {
    
// MARK:  - Variables -
   
    @Published  var isPresented = false
    @Published var isLoading = false
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
// MARK:  - Methods -
    
    
    func screenToOpen() async {
        
        do {
            await MainActor.run {
                self.isLoading = true
            }
            let registeredUser = try await fireBaseManager.fetchAppUser()
            
            if registeredUser == nil, !UserDefaults.standard.bool(forKey: "onboardingSkip") {
                
                Constants.currentState = .none
            } else {
                
                await MainActor.run {
                    
                    if let user = registeredUser {
                        Constants.currentState = Constants.State(rawValue: user.appRole)
                    } else {
                        Constants.currentState = .notLogged
                    }
                    self.isPresented = true
                }
            }
        } catch {
            print("error fetching user")
        }
    }
    
    
    

}
