//
//  ClientViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 20.06.23.
//

import Foundation
import Combine

final class ClientViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    private var cancellable =  Set<AnyCancellable>()
    
    
    @Published var name: String = ""
    @Published var changeProfileImage = false
    @Published var openCameraRoll = false
    @Published var imageURL:  URL?
    @Published var openloginView: Bool = false
    @Published var clientData: Client
    
    @Published var instInEditMode = false
    @Published var inst = ""
    @Published var phoneInEditMode = false
    @Published var phone = ""
    

// MARK:  - Methods -
    
    init(clientData: Client) {
        
        self.clientData = clientData
        
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
    
    
    func loadClientInfo() {
       
            if clientData.imageURL != "" {
                imageURL = URL(string: clientData.imageURL)
            }
            name = clientData.name
            phone = clientData.number
            inst = clientData.instURL
        

    }
    
    func addImageToUser() {
      
        guard let url = imageURL else { return }
        Task {
            do {
                try await fireBaseManager.saveClientsPhoto(imageURL: url.absoluteString, clientID: clientData.id.description)
            } catch {
                print("error while saving image from customer view")
            }
        }
    }

    func updateClientInfo() {
        fireBaseManager.updateClientInfo(number: phone, inst: inst, id: clientData.id)
        Task { [weak self] in
            guard let self = self else {return}
            let newData = await fireBaseManager.getCurrentClientInfo(id: clientData.id) ?? Client()
            await MainActor.run {
                self.clientData = newData
            }
        }
    }
    
}
