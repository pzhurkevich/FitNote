//
//  LoginViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import Foundation
import SwiftUI
import Firebase

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
    @Published var isLoading = false
    @Published var showPassword = false
    
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    var emailAlert: String {
        return isEmailValid() ? "" : "Enter a valid email address"
     }
    
    var loginAllowed: Bool {
        
            return isEmailValid()
       
    }
    
// MARK:  - Methods -
    
    func logIn() {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                await MainActor.run {
                    self.isLoading = true
                }
                let userData = try await fireBaseManager.login(mail: email, password: password)
                let registeredUser = try await fireBaseManager.fetchAppUser()
                await MainActor.run {
                    self.isLogged = userData.email != nil
                    
                    if let user = registeredUser {
                        if user.appRole != "" {
                            Constants.currentState = Constants.State(rawValue: user.appRole)
                        } else {
                            Constants.currentState = .appRoleNotChoosen
                        }
                    }
                    
                }
            } catch {
              
                let authError = AuthErrorCode.Code(rawValue: error._code)

                await MainActor.run {
                    switch authError {
                        
                    case .userNotFound:
                        self.errorText = "Cannot find the user, try with different credential"
                    case .wrongPassword:
                        self.errorText = "Password is wrong"
                    case .invalidEmail:
                        self.errorText = "Email is not valid"
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
    
    
}
