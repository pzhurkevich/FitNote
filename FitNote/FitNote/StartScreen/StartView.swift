//
//  StartView.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import SwiftUI

struct StartView: View {
    

    @StateObject var vm = StartViewViewModel()
    
    
    var body: some View {
        ZStack {
            Color.darkColor.ignoresSafeArea()
            VStack {
                
                Spacer()
                
                Image("logo")
                    .resizable()
                    .renderingMode(.template)
                    .frame(maxWidth: 100, maxHeight: 100)
                    .foregroundColor(.white)
                
                
                Text("FitNote")
                    .font(.system(size: 70, weight: .black, design: .serif))
                    .foregroundColor(Color.greenColor)
                
                Spacer()
                if vm.isLoading {
                    
                    ProgressView()
                        .scaleEffect(2)
                        .tint(Color.greenColor)
                        .padding(.bottom, 30)
                }
                
            }
        }
        .fullScreenCover(isPresented: $vm.isPresented) {
           
            switch Constants.currentState {
            case .notLogged:
                LoginView()
            case .loggedAsSelf:
                MainBarView()
            case .loggedAsTrainer:
                MainBarView()
            case .none:
                OnboardingView()
            case .noInternet:
                NetworkErrorView()
            case .appRoleNotChoosen:
                AppRoleView()
            }
            
        }
        .task {
            await vm.screenToOpen()
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
