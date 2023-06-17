//
//  CustomerViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 10.06.23.
//

import Foundation


final class CustomerViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    @Published var email: String = ""
    @Published var name: String = ""
    
    
// MARK:  - Methods -
    
    func fetchAppUserinfo() async {
        do {
           
            guard let data  =  try await self.fireBaseManager.fetchAppUser() else { return }
          
            await MainActor.run {
                self.email = data.email
                self.name = data.name
            }
                
        } catch {
            
            print("Can't get appUser data from firebase")
        }
     
    }
    
    

}




