//
//  TrainerViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 19.06.23.
//

import Foundation
import UIKit
import Combine


final class TrainerViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    private var cancellable =  Set<AnyCancellable>()
    
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var changeProfileImage = false
    @Published var openCameraRoll = false
    @Published var imageURL:  URL?
    @Published var openloginView: Bool = false
    
    @Published var todayClients : [ClientTask] = []
    @Published var displayName: String = ""
    @Published var lastWorkouts: Dictionary<String, String> = [:]
    
    
// MARK:  - Methods -
    
    init() {
        $changeProfileImage
            .sink { [weak self] _ in
                
                guard let self = self else { return }
                self.addImageToUser()
            }
            .store(in: &cancellable)
    }

    deinit {
            cancellable.removeAll()
        }
    
    
    func fetchAppUserinfo() async {
        do {
           
            guard let data  =  try await self.fireBaseManager.fetchAppUser() else { return }
          
            await MainActor.run {
                self.email = data.email
                self.name = data.name
                
                if data.imageURL != "" {
                   
                    imageURL = URL(string: data.imageURL)
                    
                }
            }
                
        } catch {
            
            print("Can't get appUser data from firebase")
        }
     
    }
    
    func addImageToUser() {
        guard let url = imageURL else { return }
        Task {
            do {
                try await fireBaseManager.saveImage(imageURL: url.absoluteString)
            } catch {
                print("error while saving image from customer view")
            }
        }
    }

    func signOutAppUser() {
        fireBaseManager.signOut()
        self.openloginView = true
    }
    
    func deleteAppUser() {
        Task { [weak self] in
            guard let self = self else {return}
            
           await fireBaseManager.deleteAppUser()
            
            await MainActor.run {
              self.openloginView = true
            }
            
        }
    }
    
    func fetchTasks() async {
           
           let clientsTasksFromServer  =  await self.fireBaseManager.fetchClientsToPlanner()
           let today = Date()
           let  todayClientsTasks = clientsTasksFromServer.first(where: { $0.taskDate.getDateComponents() == today.getDateComponents() })
           guard let  clientList = todayClientsTasks?.task else {return}
           
           await MainActor.run {
               self.todayClients = clientList
           }
       }

    func lastWorkout() async {
        
        for clientTask in todayClients {
            let workoutsFromServer = await self.fireBaseManager.fetchClientsWorkouts(clientID: clientTask.client.id)
            if !workoutsFromServer.isEmpty {
                let lastWorkout = workoutsFromServer.first(where: { $0.dateWorkout.timeIntervalSince1970 <= Date().timeIntervalSince1970 })
                
                guard let name = lastWorkout else { return }
                await MainActor.run {
                    lastWorkouts["\(clientTask.client.id)"] = name.nameWorkout
                }
                
            }
        }
    }
}
