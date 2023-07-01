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
    func saveClientsPhoto(imageURL: String, clientID: String) async throws
    func updateClientInfo(number: String, inst: String, id: String)
    func getCurrentClientInfo(id: String) async -> Client?
    func deleteClientData(docId: String)
    func saveClientWorkout(name: String, date: Date, workout: [OneExersice], clientID: String) async
    func fetchClientsWorkouts(clientID: String) async -> [Workout]
    func saveCustomerWorkout(name: String, date: Date, workout: [OneExersice]) async
    func fetchCustomerWorkouts() async -> [Workout]
}


class FirebaseManager: FirebaseManagerProtocol {

// MARK: - Variables -
    
    var userSession: FirebaseAuth.User?
    
       
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
    
    func saveImage(imageURL: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
       
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
    
    func saveCustomerWorkout(name: String, date: Date, workout: [OneExersice]) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let AppUserWorkout = Workout(nameWorkout: name, dateWorkout: date, allExercises: workout)
            let encodedWorkout = try Firestore.Encoder().encode(AppUserWorkout)
            try await Firestore.firestore().collection("appUsers").document(uid).collection("workouts").document(AppUserWorkout.id.uuidString).setData(encodedWorkout)
        } catch {
            print (error.localizedDescription)
        }
    }
    
    
    
    func fetchCustomerWorkouts() async -> [Workout] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        var allWorkouts: [Workout] = []
        do {
            let snapshot = try await Firestore.firestore().collection("appUsers").document(uid).collection("workouts").getDocuments()
            allWorkouts = try snapshot.documents.map { try $0.data(as: Workout.self) }
        } catch {
            print("error while fetching")
        }
        
        return allWorkouts
    }
    
    
    
    // MARK: - Functions for Clients -
    
    func addClient(name: String, instURL: String, phoneNumber: String, imageURL: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let id = UUID().uuidString
        do {
            let client = Client(id: id, name: name, instURL: instURL, number: "-", imageURL: "")
            let encodedClient = try Firestore.Encoder().encode(client)
            try await Firestore.firestore().collection("clientsDB").document(uid).collection("clients").document(id).setData(encodedClient)
            
        } catch {
            print (error.localizedDescription)
      
        }
    }
    
    
    func fetchClients() async -> [Client] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        var allClients: [Client] = []
        do {
            let snapshot = try await Firestore.firestore().collection("clientsDB").document(uid).collection("clients").getDocuments()
            allClients = try snapshot.documents.map { try $0.data(as: Client.self) }
        } catch {
            print("Can't fetch clients Data")
           
        }
       
        return allClients
    }
    
    func saveClientsPhoto(imageURL: String, clientID: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
       
        let photoName = UUID().uuid
        
        let storageRef = Storage.storage().reference().child("\(clientID)/\(photoName).jpeg")
       
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
        try await Firestore.firestore().collection("clientsDB").document(uid).collection("clients").document(clientID).setData(["imageURL": imageURLString], merge: true)
    }
    
    func updateClientInfo(number: String, inst: String, id: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
       Firestore.firestore().collection("clientsDB").document(uid).collection("clients").document(id).setData([
        "number": number,
        "instURL": inst
       ], merge: true)
    }
    
    func getCurrentClientInfo(id: String) async -> Client? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
       
        do {
            let snapshot = try await Firestore.firestore().collection("clientsDB").document(uid).collection("clients").document(id).getDocument()
            let client = try snapshot.data(as: Client.self)
            return client
        } catch {
            print("Can't fetch clients Data")
           return nil
        }
    
    }
    
    
    
    func deleteClientData(docId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("clientsDB").document(uid).collection("clients").document(docId).delete()
    }
    
    //MARK: - Workout functions -
    
    func saveClientWorkout(name: String, date: Date, workout: [OneExersice], clientID: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let clientWorkout = Workout(nameWorkout: name, dateWorkout: date, allExercises: workout)
            let encodedClientWorkout = try Firestore.Encoder().encode(clientWorkout)
            try await Firestore.firestore().collection("clientsDB").document(uid).collection("clients").document(clientID).collection("workouts").document(clientWorkout.id.uuidString).setData(encodedClientWorkout)
        } catch {
            print (error.localizedDescription)
        }
    }
    
    func fetchClientsWorkouts(clientID: String) async -> [Workout] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        var allWorkouts: [Workout] = []
        do {
            let snapshot = try await Firestore.firestore().collection("clientsDB").document(uid).collection("clients").document(clientID).collection("workouts").getDocuments()
            
            allWorkouts = try snapshot.documents.map { try $0.data(as: Workout.self) }
        } catch {
            print("error while fetching")
           
        }
       
        return allWorkouts
    }
    
}
