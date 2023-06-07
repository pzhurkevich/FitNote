//
//  OnboardingView.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            ZStack {
                
                Image("onboarding")
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    Rectangle()
                        .frame(width: 1000, height: 400)
                        .foregroundColor(Color("mainDark"))
                        .rotationEffect(.degrees(160))
                    .offset(y: 430)

                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            
            Spacer()
            
            Button {
                
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
                .background(Color("mainGreen"))
                .clipShape(Capsule())
            }
            

            Spacer()
        }
    }
        
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
