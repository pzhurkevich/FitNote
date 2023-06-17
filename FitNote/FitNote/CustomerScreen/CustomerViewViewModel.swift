//
//  CustomerViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 10.06.23.
//

import Foundation
import UIKit


final class CustomerViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    @Published var email: String = ""
    @Published var name: String = ""
    
    @Published var changeProfileImage = false
    
    @Published var openCameraRoll = false
    
    @Published var imageSelected = UIImage()
    
    @Published var imageURL:  URL?
    @Published var openloginView: Bool = false
// MARK:  - Methods -
    
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
    
    func addImageToUser() async {
        guard let url = imageURL else { return }
        do {
            try await fireBaseManager.saveImage(imageURL: url.absoluteString)
        } catch {
            print("error while saving image from customer view")
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
    
}




