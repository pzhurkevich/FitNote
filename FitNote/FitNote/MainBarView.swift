//
//  MainBarView.swift
//  FitNote
//
//  Created by Pavel on 11.07.23.
//

import SwiftUI

struct MainBarView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.secondaryDark)
        UITabBar.appearance().barTintColor = .white
       }
    
    var body: some View {
        NavigationView {
            TabView {
                if Constants.currentState == .loggedAsTrainer {
                    TrainerView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    ClientsListView()
                        .tabItem {
                            Image(systemName: "person.3")
                            Text("Clients")
                        }
                    Planner()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Planner")
                        }
                } else {
                    CustomerView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    WorkoutView(vm: WorkoutViewViewModel(clientData: Client()))
                        .tabItem {
                            Image(systemName: "figure.strengthtraining.traditional")
                            Text("Workout")
                        }
                    HistoryView(vm: HistoryViewViewModel(clientData: Client()))
                        .tabItem {
                            Image(systemName: "list.bullet.rectangle")
                            Text("History")
                        }
                }
            }
            .accentColor(Color.greenColor)
        }
    }
}

struct MainBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainBarView()
    }
}
