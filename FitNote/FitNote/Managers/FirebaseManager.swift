//
//  FirebaseManager.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol FirebaseManagerProtocol {
    var userSession: FirebaseAuth.User? { get }
    func register(mail: String, password: String, name: String) async throws -> User
    func login(mail: String, password: String) async throws -> User
    func fetchAppUser() async throws -> AppUser?
    func updateUser(role: String)
    
}


class FirebaseManager: FirebaseManagerProtocol {

// MARK: - Variables -
    
    var userSession: FirebaseAuth.User?
    
    
// MARK: - Registration and Login Methods -
    
    func register(mail: String, password: String, name: String) async throws -> User {
        do {
            let result =  try await Auth.auth().createUser(withEmail: mail, password: password)
            self.userSession = result.user
            let appUser = AppUser(id: result.user.uid, name: name, email: mail, imageURL: "", appRole: "")
            let encodedUser = try Firestore.Encoder().encode(appUser)
            try await Firestore.firestore().collection("appUsers").document(appUser.id).setData(encodedUser)
            return result.user
        } catch {
            print (error.localizedDescription)
            throw error
        }
    }
    
    func login(mail: String, password: String) async throws -> User {
        do {
            return try await Auth.auth().signIn(withEmail: mail, password: password).user
        } catch {
            print (error.localizedDescription)
            throw error
        }
    }
    
    
    func fetchAppUser() async throws -> AppUser? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        do {
            let snapshot = try await Firestore.firestore().collection("appUsers").document(uid).getDocument()
            let appUser = try snapshot.data(as: AppUser.self)
            return appUser
        } catch {
            print("Can't fetch appUser Data")
            return nil
        }
    }
    
    
    
    func updateUser(role: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("appUsers").document(uid).setData( ["appRole": role], merge: true)
      
        
        
//        let appUser = AppUser(id: result.user.uid, name: name, email: mail, imageURL: "", appRole: "")
//        let encodedUser = try Firestore.Encoder().encode(appUser)
//        try aFirestore.firestore().collection("appUsers").document(appUser.id).setData(encodedUser)
    }
    
}
