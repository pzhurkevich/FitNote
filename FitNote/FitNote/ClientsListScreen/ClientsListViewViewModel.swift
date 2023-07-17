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
    @Published var names: [String] = []
    @Published var showingAlert = false
    @Published var nameAlert = false
    @Published var newClientName = ""
    
    @Published var nameErrorText: nameError = .emptyName
    
    enum nameError: String {
        
        case emptyName = "Name cannot be empty"
        case nameExist = "Client with same name is already exists"
    }
    
    
    // MARK:  - Methods -
    
    func addNewClient() {
        
        guard !newClientName.isEmpty, !names.contains(where: {$0.caseInsensitiveCompare(self.newClientName) == .orderedSame}) else {
               self.nameErrorText = self.newClientName.isEmpty ? .emptyName : .nameExist
               self.nameAlert = true
            return
        }
        
        Task { [weak self] in
            guard let self = self else {return}
            
           await fireBaseManager.addClient(name: newClientName, instURL: "-", phoneNumber: "-", imageURL: "")
            let clientsFromServer = await fireBaseManager.fetchClients()
            await MainActor.run {
                self.clients = clientsFromServer
            }
        }
        
        print("new client created")
    }
    
    func deleteClient(client: Client) {
        fireBaseManager.deleteClientData(docId: client.id)
        clients = clients.filter { $0.id != client.id}
        
    }
    
    func fetchClients() async {

           
            let clientsFromServer  =  await self.fireBaseManager.fetchClients()
          
            await MainActor.run {
                self.names = clientsFromServer.map { $0.name }
                self.clients = clientsFromServer
            }
      
    }
    
    
    func delete(at offsets: IndexSet, id: String) {
           clients.remove(atOffsets: offsets)
        fireBaseManager.deleteClientData(docId: id)
       }
    
}
