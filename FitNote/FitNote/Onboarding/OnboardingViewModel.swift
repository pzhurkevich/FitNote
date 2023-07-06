//
//  OnboardingViewModel.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import Foundation


final class OnboardingViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    @Published  var isPresented = false
    @Published  var currentTab = 0
    
    @Published var list: [OnboardingData] = [
        OnboardingData(id: 0, backgroundImage: "onboarding", title: "Advantage", primaryText: "Use this app for powerful and effective workouts"),
        OnboardingData(id: 1, backgroundImage: "role", title: "Usability", primaryText: "If you train others, this app will help you keep track of your clients, keep a history of their workouts, and put their next visit on app calendar"),
        OnboardingData(id: 2, backgroundImage: "onboarding2", title: "Safety", primaryText: "Choose from over 800 exercises, each one with instructions to make your workout safe and productive")
    ]
    
// MARK:  - Methods -
    

}
