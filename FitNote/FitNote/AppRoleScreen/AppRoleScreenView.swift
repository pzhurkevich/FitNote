//
//  AppRoleScreenView.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import SwiftUI

struct AppRoleScreenView: View {
    
    @StateObject var vm = AppRoleScreenViewModel()
    
    var body: some View {
        ZStack {
            
            Color("mainDark").ignoresSafeArea()
         
        
            
            VStack {
                
                Text("Hello, user! How will you use the app?")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding()
              
                ZStack {
                    
                    Image("role")
                        .resizable()
                        .scaledToFill()
                    
                    
                    VStack{
                        HStack {
                            Button {
                               
                            } label: {
                                
                                Text("I'm train others")
                                    .foregroundColor(.black)
                                    .fontDesign(.rounded)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("mainGreen"))
                                    .clipShape(Capsule())
                            }.padding()
                           
                            Button {
                                vm.customAlert.toggle()
                                vm.textForAlert = "By choosing this app role you will be able to keep track of your clients, track their workouts and changes in their body parameters"
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
                               
                            } label: {
                                
                                Text("I'm train by myself")
                                    .foregroundColor(.black)
                                    .fontDesign(.rounded)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("mainGreen"))
                                    .clipShape(Capsule())
                            }.padding()
                            
                            Button {
                                vm.customAlert.toggle()
                                vm.textForAlert = "By choosing this role of the app you will be able to keep records only of your workouts, monitor changes in your body parameters only"
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
                CustomAlertView(show: $vm.customAlert, text: vm.textForAlert)
            }
            
            
        }
    }
}

struct AppRoleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AppRoleScreenView()
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
                  
                    .foregroundColor(Color("mainGreen"))
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
