//
//  RegisterViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import Foundation
import Firebase

final class RegisterViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var name: String = ""
    @Published var errorText: String = "" {
        didSet {
            showingAlert = true
        }
    }
    
    
    @Published  var isRegistered = false
    @Published var showingAlert = false
    @Published  var isLoading = false
    @Published  var showPassword = false
    @Published  var showConfirm = false
    
   var emailAlert: String {
       return isEmailValid() ? "" : "Enter a valid email address"
    }
    
    var passwordAlert: String {
        return isPasswordValid() ? "" : "Must be more than 6 characters"
    }
    
    var passwordConfirmAlert: String {
        return password == passwordConfirm ? "" : "Password do not match"
    }
    
    var nameAlert: String {
        return isNameValid() ? "" : "Name cannot be empty" 
    }
    
    var registrationAllowed: Bool {
        if password != passwordConfirm ||
        !isPasswordValid() ||
        !isEmailValid() ||
            !isNameValid() {
            return false
        }
        return true
    }
    
    
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
// MARK:  - Methods -
    
    func register () {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                await MainActor.run {
                    self.isLoading = true
                }
                let userData = try await fireBaseManager.register(mail: email, password: password, name: name)
                    
                    await MainActor.run {
                        self.isRegistered = userData.email != nil
                    }
                
            } catch {
                let authError = AuthErrorCode.Code(rawValue: error._code)
                print(error.localizedDescription)
                await MainActor.run {
                    
                    switch authError {
                        
                    case .accountExistsWithDifferentCredential:
                        self.errorText = "Account already exist with different credetial"
                    case .weakPassword:
                        self.errorText = "Password is week, use at least 6 characters"
                    case .invalidEmail:
                        self.errorText = "Email is not valid"
                    case .emailAlreadyInUse:
                        self.errorText = "The email address is already in use by another account"
                    default:
                        self.errorText =  "Unknown error occurred"
                    }
                    
                    self.isLoading = false
                    
                }
            }
        }
    }
    
    func isEmailValid() -> Bool {
        let emailSample = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailSample.evaluate(with: email)
    }
    func isPasswordValid() -> Bool {
        return password.count >= 6
    }
    func isNameValid() -> Bool {
        return name.count > 0
    }
    
    
    
}
