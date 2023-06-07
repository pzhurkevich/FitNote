//
//  StartScreenView.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import SwiftUI

struct StartScreenView: View {
    
    
    @StateObject var vm = StartScreenViewModel()
    
    
    var body: some View {
        ZStack {
            Color("mainDark").ignoresSafeArea()
            VStack {
                
                Spacer()
                
                Image("logo")
                    .resizable()
                    .renderingMode(.template)
                    .frame(maxWidth: 100, maxHeight: 100)
                    .foregroundColor(.white)
                
                
                Text("FitNote")
                    .font(.system(size: 70, weight: .black, design: .serif))
                    .foregroundColor(Color("mainGreen"))
                
                Spacer()
                
                ProgressView()
                    .scaleEffect(2)
                    .tint(Color("mainGreen"))
                    .padding(.bottom, 30)
                
                
            }
        }
        .fullScreenCover(isPresented: $vm.isPresented) {
            OnboardingView()
        }
        .onAppear {
            vm.timeCountForStartScreen()
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView()
    }
}
