//
//  AppRoleView.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import SwiftUI

struct AppRoleView: View {
    
    @StateObject var vm = AppRoleViewViewModel()
    
    var body: some View {
        ZStack {
            
            Color.darkColor.ignoresSafeArea()
         
        
            
            VStack {
                
                VStack {
                    Text("Hello, user! How will you use the app?")
                       
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(30)
                }.padding(.top, 10)
                 
              
                ZStack {
                    
                    VStack {
                        Spacer()
                        Image("role")
                            .resizable()
                        .scaledToFill()
                        
                    }.ignoresSafeArea()
                    
                    
                    VStack{
                        HStack {
                            Button {
                                
                                vm.updateRoleForUser(role: .loggedAsTrainer)
                                vm.roleScreen = .trainer
                            } label: {
                                
                                Text("I train others")
                                    .foregroundColor(.black)
                                    .fontDesign(.rounded)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.greenColor)
                                    .clipShape(Capsule())
                            }.padding()
                           
                            Button {
                                vm.customAlert.toggle()
                                vm.textForAlert = .textForTrainers
                            } label: {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 10)
                                    
                            }

                        }.padding(.horizontal, 20)
                        
                        HStack {
                            Button {
                                
                                vm.updateRoleForUser(role: .loggedAsSelf)
                                vm.roleScreen = .customer
                               
                            } label: {
                                
                                Text("I train by myself")
                                    .foregroundColor(.black)
                                    .fontDesign(.rounded)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.greenColor)
                                    .clipShape(Capsule())
                            }.padding()
                            
                            Button {
                                vm.customAlert.toggle()
                                vm.textForAlert = .textForSelfTrain
                            } label: {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 10)
                            }
                            
                        }.padding(.horizontal, 20)
                    }
                }
                            
            }
            
            if vm.customAlert {
                CustomAlertView(show: $vm.customAlert, text: vm.textForAlert.rawValue)
            }
            
            
        }
        .fullScreenCover(item: $vm.roleScreen) { item in
            switch item {
            case .customer:
                CustomerView(clientData: .init(name: "Alisa", instURL: "", number: "", imageURL: ""))
            case .trainer:
                TrainerView()
            }
        }
    }
}

struct AppRoleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AppRoleView()
    }
}


struct CustomAlertView: View {
    
    @Binding var show: Bool
    @State var text: String
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            VStack{
                Text(text)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 30)
            .background(BlurView())
            .cornerRadius(25)
            
            Button {
                show.toggle()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20, weight: .semibold))
                  
                    .foregroundColor(Color.greenColor)
            }
            .padding([.top, .trailing], 8)
          

        }
        .padding([.trailing, .leading], 30)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
       
        .background(Color.primary.opacity(0.65))
    }
    
}

struct BlurView : UIViewRepresentable {
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
      return view
    }
}
