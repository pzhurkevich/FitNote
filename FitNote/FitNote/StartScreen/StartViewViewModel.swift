//
//  StartViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import Foundation
import SwiftUI
import Network

final class StartViewViewModel: ObservableObject {
    
// MARK:  - Variables -
   
    @Published  var isPresented = false
    @Published var isLoading = false
    @Published var isConnected = true
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")

// MARK:  - Methods -
    
    init() {
            monitor.pathUpdateHandler =  { [weak self] path in
                guard let self = self else { return }
                    self.isConnected = path.status == .satisfied 
                
            }
            monitor.start(queue: queue)
        }
    
    
    
    func screenToOpen() async {
        await MainActor.run {
            self.isLoading = true
        }
        if isConnected {
            do {
                
                let registeredUser = try await fireBaseManager.fetchAppUser()
                
                if registeredUser != nil, !UserDefaults.standard.bool(forKey: "onboardingSkip") {
                    fireBaseManager.signOut()
                    Constants.currentState = .none
                    await MainActor.run {
                        self.isPresented = true
                    }
                } else {
                    
                    if registeredUser == nil, !UserDefaults.standard.bool(forKey: "onboardingSkip") {
                        
                        Constants.currentState = .none
                        await MainActor.run {
                            self.isPresented = true
                        }
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
                }
            } catch {
                print("error fetching user")
            }
        } else {
            Constants.currentState = .noInternet
            await MainActor.run {
                self.isPresented = true
            }
        }
    }
    
    
    

}
