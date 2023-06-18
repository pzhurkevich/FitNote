//
//  OnboardingView.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboardingSkip") var skip = false
    
    @StateObject var vm = OnboardingViewModel()
    
    var body: some View {
  
            ZStack {
                
                VStack {
                    Image("onboarding")
                        .resizable()
                    .scaledToFit()
                    Spacer()
                }
                
               
                    Rectangle()
                    .frame(width: 1000, height: 400)
                    .foregroundColor(Color.darkColor)
                    .rotationEffect(.degrees(160))
                    .offset(y: UIScreen.main.bounds.size.height / 2 )

                VStack {
                    Spacer()
                    Button {
                        vm.isPresented.toggle()
                        skip.toggle()
                    } label: {
                        HStack {
                            Text("Start Now")
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                            
                            Image(systemName: "chevron.forward")
                                .fontWeight(.bold)
                        }
                        .tint(.black)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .background(Color.greenColor)
                        .clipShape(Capsule())
                    }
                    .padding(.bottom, 50)
                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .fullScreenCover(isPresented: $vm.isPresented) {
                LoginView()
        }
    }
        
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
