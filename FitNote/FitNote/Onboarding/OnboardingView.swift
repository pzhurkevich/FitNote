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
        
//        ZStack {
//            Color.black.ignoresSafeArea()
            
            TabView(selection: $vm.currentTab,
                    content:  {
                ForEach(vm.list) { data in
                    ZStack {
                        
                        
                        Image(data.backgroundImage)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .ignoresSafeArea()
                        
                        
                        VStack {
                            
                            Spacer()
                            VStack(spacing: 0) {
                                Text(data.title)
                                    .font(.title)
                                    .foregroundColor(.greenColor)
                                    .padding(.top, 10)
                                    .foregroundColor(.greenColor)
                                
                                Text(data.primaryText)
                                    .padding(20)
                                    .font(.system(.title2, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                  
                            }
                            .background(Color.secondaryDark)
                            .opacity(0.9)
                      
                            
                            
                            
                        }
                        .padding(.bottom, 190)
                        if data.id == 2 {
                          
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
                            .padding(.bottom, 60)
                            }
                        }
                    }
                    
                    .fullScreenCover(isPresented: $vm.isPresented) {
                        LoginView()
                    }
                    .tag(data.id)
                }
                
            })
            .frame(minWidth: 0, maxWidth: .infinity)
            .ignoresSafeArea()
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        //}
       
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
