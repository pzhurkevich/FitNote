//
//  StartViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import Foundation
import SwiftUI


final class StartViewViewModel: ObservableObject {
    
// MARK:  - Variables -
   
    @Published  var isPresented = false
    
// MARK:  - Methods -
    
    func timeCountForStartScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {return}
            self.isPresented = true
        }
    }
    
    
    @ViewBuilder
    func nextView() -> some View {
        switch Constants.currentState {
        case .notLogged:
           LoginView()
        case .loggedAsSelf:
            CustomerView()
        case .loggedAsTrainer:
            EmptyView()
        case .none:
            OnboardingView()
        }

    }
    
    

}
