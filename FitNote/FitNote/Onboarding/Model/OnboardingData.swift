//
//  OnboardingData.swift
//  FitNote
//
//  Created by Pavel on 4.07.23.
//

import Foundation

struct OnboardingData: Hashable, Identifiable {
    let id: Int
    let backgroundImage: String
    let title: String
    let primaryText: String
    
    init(id: Int = 0, backgroundImage: String = "onboarding", title: String = "title", primaryText: String = "hello") {
        self.id = id
        self.backgroundImage = backgroundImage
        self.primaryText = primaryText
        self.title = title
    }
}
