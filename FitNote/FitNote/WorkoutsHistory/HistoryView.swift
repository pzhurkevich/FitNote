//
//  HistoryView.swift
//  FitNote
//
//  Created by Pavel on 29.06.23.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var vm: HistoryViewViewModel
    
    var body: some View {
        NavigationStack {
            List(vm.workoutsToDisplay) { workout in
                Text(workout.nameWorkout)
                ForEach(workout.allExercises) { exe in
                    Text(exe.name)
                        .padding(.leading, 30)
                    
                }
                    }
                    .navigationTitle("Contacts")
                
                }
        .task {
            await vm.getWorkouts()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(vm: HistoryViewViewModel(clientData: Client(id: "", name: "User", instURL: "", number: "", imageURL: "")))
    }
}
