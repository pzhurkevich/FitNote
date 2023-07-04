//
//  RegisterView.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var vm = RegisterViewViewModel()
    
    var body: some View {
            ZStack {
                
               Color.darkColor.ignoresSafeArea()
                
                VStack{
                    
                    Image(systemName: "chevron.up.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.greenColor)
                        .padding()
                    
                    Text("Registration")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    TextField("", text: $vm.name, prompt: Text("Name").foregroundColor(.white))
                        .foregroundColor(Color.greenColor)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                        .padding()
                    
                    TextField("", text: $vm.email, prompt: Text("Email").foregroundColor(.white))
                        .foregroundColor(Color.greenColor)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                        .padding()
                    
                    SecureField("", text: $vm.password, prompt: Text("Password").foregroundColor(.white))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color.greenColor)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                        .padding()
                    
                    Button {
                        
                        vm.register()
                        
                        
                    } label: {
                        
                        Text("Create Account")
                            .foregroundColor(.black)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.greenColor)
                            .clipShape(Capsule())
                    }
                    
                    .padding([.horizontal, .vertical], 16)

                }
                .padding(.vertical, 30)
                .background( RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(Color.secondaryDark)
                )
                .padding(.horizontal, 20)
               
               if vm.isLoading {
                   ProgressView {
                                  Text("Loading")
                                      .foregroundColor(.black)
                                      .bold()
                   }
                   .padding(20)
                   .background(Color.greenColor.opacity(0.6))
                   .clipShape(RoundedRectangle(cornerRadius: 20))
                   .frame(maxWidth: .infinity,  maxHeight: .infinity )
                   .background(Color.black.opacity(0.6))
                   .edgesIgnoringSafeArea(.all)
               }
               
           }
           .fullScreenCover(isPresented: $vm.isRegistered) {
               AppRoleView()
       }
           .alert("", isPresented: $vm.showingAlert) {
               Button("Ok", role: .cancel) {}
           } message: {
               Text(vm.errorText)
           }

    }
}

struct RegisterScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
