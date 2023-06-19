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
    func updateUserRole(role: String)
    func signOut()
    func saveImage(imageURL: String) async throws
    func deleteAppUser() async
    func addClient(name: String, instURL: String, phoneNumber: String, imageURL: String) async
    func fetchClients() async -> [Client]
}


class FirebaseManager: FirebaseManagerProtocol {

// MARK: - Variables -
    
    var userSession: FirebaseAuth.User?
    
    
// MARK: - Registration and Login Methods -
    
  // MARK: - Functions for App User-
    
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
    
    func updateUserRole(role: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("appUsers").document(uid).setData( ["appRole": role], merge: true)
    }
    
   
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            Constants.currentState = .notLogged
            UserDefaults.standard.set(Constants.currentState?.rawValue, forKey: "appState")
            
        } catch {
            print("failed to signOut")
        }
    }
    
    func deleteAppUser() async {
        guard let user = Auth.auth().currentUser else { return }
        do {
            try await user.delete()
            try await Firestore.firestore().collection("appUsers").document(user.uid).delete()
            Constants.currentState = .notLogged
            UserDefaults.standard.set(Constants.currentState?.rawValue, forKey: "appState")
            
        } catch {
            print("error while deleting account")
        }
    }
    
    // MARK: - Functions for Clients -
    
    func addClient(name: String, instURL: String, phoneNumber: String, imageURL: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let client = Client(name: name, instURL: instURL, number: "", imageURL: "")
            let encodedClient = try Firestore.Encoder().encode(client)
            try await Firestore.firestore().collection("clientsDB").document(uid).collection("clients").document(client.id.description).setData(encodedClient)
            
        } catch {
            print (error.localizedDescription)
      
        }
    }
    
    
    func fetchClients() async -> [Client] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        var allClients: [Client] = []
        do {
            let snapshot = try await Firestore.firestore().collection("clientsDB").document(uid).collection("clients").getDocuments()
            
           try snapshot.documents.forEach { doc in
               let client = try doc.data(as: Client.self)
               allClients.append(client)
            }

        } catch {
            print("Can't fetch clients Data")
           
        }
       
        return allClients
    }
    
    //MARK: - Other functions -
    
    func saveImage(imageURL: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(uid)
        let photoName = UUID().uuid
        
        let storageRef = Storage.storage().reference().child("\(uid)/\(photoName).jpeg")
       
        guard let dataURL = URL(string: imageURL) else {return}

        let imageData = try Data(contentsOf: dataURL)
        
        guard let image = UIImage(data: imageData)?.jpegData(compressionQuality: 0.2) else {
            print("error while creating image")
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        var imageURLString = ""
   
        do {
            let _ = try await storageRef.putDataAsync(image, metadata: metadata)
            print("image saved")
            
            do {
                let imageDownloadURL = try await storageRef.downloadURL()
                imageURLString = imageDownloadURL.absoluteString
            } catch {
                print("error while getting image URL")
            }
            
        } catch {
            print("error while uploading image to firebase")
        }
        
        try await Firestore.firestore().collection("appUsers").document(uid).setData( ["imageURL": imageURLString], merge: true)
        
    }
    
}
