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
    
    @Published var tappedID: UUID?
    
    
    
    // MARK:  - Methods -
    init(clientData: Client) {
        self.clientData = clientData
        print(clientData)
    }
    


  
        func getWorkouts() async {
            do {
                guard let data = try await self.fireBaseManager.fetchAppUser() else { return }

                let workoutsFromServer: [Workout]
                
                if Constants.currentState == .loggedAsSelf {
                    workoutsFromServer = await self.fireBaseManager.fetchCustomerWorkouts()
                } else {
                    workoutsFromServer = await self.fireBaseManager.fetchClientsWorkouts(clientID: clientData.id)
                }

                await MainActor.run {
                    self.workoutsToDisplay = workoutsFromServer
                }
            } catch {
                print("Can't fetch AppUser data for load workouts")
            }
        }
    
}
