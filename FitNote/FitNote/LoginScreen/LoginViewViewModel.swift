//
//  LoginViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import Foundation
import SwiftUI


final class LoginViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorText: String = "" {
        didSet {
            showingAlert = true
        }
    }
    @Published  var showingAlert = false
    @Published  var isLogged = false
    @Published  var openRegisterScreen = false
  
    
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
// MARK:  - Methods -
    
    func logIn() {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let userData = try await fireBaseManager.login(mail: email, password: password)
                let registeredUser = try await fireBaseManager.fetchAppUser()
                await MainActor.run {
                    self.isLogged = userData.email != nil
                    if let user = registeredUser {
                        Constants.currentState = Constants.State(rawValue: user.appRole)
                        UserDefaults.standard.set(user.appRole, forKey: "appState")
                    }
                }
            } catch {
                    self.errorText = error.localizedDescription.description
            }
        }
    }
    
    
    @ViewBuilder
    func nextView() -> some View {
        switch Constants.currentState {
        case .notLogged:
           LoginView()
        case .loggedAsSelf:
            CustomerView()
        case .loggedAsTrainer:
            EmptyView()
        case .none:
            OnboardingView()
        }

    }
    
}
