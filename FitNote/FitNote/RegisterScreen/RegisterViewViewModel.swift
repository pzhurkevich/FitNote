//
//  RegisterViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import Foundation

final class RegisterViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var errorText: String = "" {
        didSet {
            showingAlert = true
        }
    }
    
    
    @Published  var isRegistered = false
    @Published var showingAlert = false
    
    
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
// MARK:  - Methods -
    
    func register () {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let userData = try await fireBaseManager.register(mail: email, password: password, name: name)
                    
                    await MainActor.run {
                        self.isRegistered = userData.email != nil
                    }
                
            } catch {
             
                    self.errorText = error.localizedDescription.description
                
            }
        }
    }
}
