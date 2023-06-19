//
//  ClientsListViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 19.06.23.
//

import Foundation

final class ClientsListViewViewModel: ObservableObject {
    
    // MARK:  - Variables -
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    @Published var clients: [Client] = []
    @Published var showingAlert = false
    @Published var newClientName = ""
    // MARK:  - Methods -
    
    func addNewClient() {
        Task { [weak self] in
            guard let self = self else {return}
            
           await fireBaseManager.addClient(name: newClientName, instURL: "", phoneNumber: "", imageURL: "")
            let clientsFromServer = await fireBaseManager.fetchClients()
            await MainActor.run {
                self.clients = clientsFromServer
            }
        }
        
        print("new client created")
    }
    func fetchClients() async {

           
            let clientsFromServer  =  await self.fireBaseManager.fetchClients()
          
            await MainActor.run {
                self.clients = clientsFromServer
            }
      
    }
    
}
