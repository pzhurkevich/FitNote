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
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
// MARK:  - Methods -
    
    func timeCountForStartScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {return}
            self.isPresented = true
        }
    }
    
    func screenToOpen() async {
        
        do {
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
                }
            }
        } catch {
            print("error fetching user")
        }
    }
    
    
    

}
