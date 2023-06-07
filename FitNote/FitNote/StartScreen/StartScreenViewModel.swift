//
//  StartScreenViewModel.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import Foundation


final class StartScreenViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    @Published  var isPresented = false
    
// MARK:  - Methods -
    
    func timeCountForStartScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {return}
            self.isPresented = true
        }
    }
}
