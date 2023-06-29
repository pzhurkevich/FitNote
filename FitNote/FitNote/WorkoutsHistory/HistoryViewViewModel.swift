//
//  HistoryViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 29.06.23.
//

import Foundation

final class HistoryViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    @Published var clientData: Client
    @Published var workoutsToDisplay: [Workout] = []

// MARK:  - Methods -
    init(clientData: Client) {
        self.clientData = clientData
    }
   
        func getWorkouts() async {
            let workoutsFromServer  =  await self.fireBaseManager.fetchCustomerWorkouts()
    
            await MainActor.run {
             
                    self.workoutsToDisplay = workoutsFromServer
                
    
    
            }
        }
    
}
