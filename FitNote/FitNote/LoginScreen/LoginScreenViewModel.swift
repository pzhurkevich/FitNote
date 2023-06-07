//
//  LoginScreenViewModel.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import Foundation


final class LoginScreenViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorText: String = ""
    @Published  var showingAlert = false
    @Published  var isLogged = false
    
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
// MARK:  - Methods -
    
    func logIn() {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let userData = try await fireBaseManager.login(mail: email, password: password)
                await MainActor.run {
                    self.isLogged = userData.email != nil
                }
            } catch {
                await MainActor.run {
                    self.showingAlert = true
                    self.errorText = error.localizedDescription.description
                }
            }
        }
    }
    
    
}
