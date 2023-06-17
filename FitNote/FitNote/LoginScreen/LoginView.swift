//
//  LoginView.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var vm = LoginViewViewModel()
    
    
    var body: some View {
       
            ZStack {
                
                Color.darkColor.ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(Color.secondaryDark)
                    .frame(maxWidth: UIScreen.main.bounds.size.width * 0.85, maxHeight: UIScreen.main.bounds.size.height * 0.65)
                VStack{
                    
                    Image(systemName: "chevron.right.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.greenColor)
                        .padding()
                    
                    Text("Sign In")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
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
                        vm.logIn()
                    } label: {
                        
                        Text("Enter")
                            .foregroundColor(.black)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.greenColor)
                            .clipShape(Capsule())
                    }
                    
                    .padding([.horizontal, .vertical], 16)
                    
                    Spacer()
                }
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.85, maxHeight: UIScreen.main.bounds.size.height * 0.55)
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Need an account?")
                            .foregroundColor(.white)
                        
                        Button {
                            vm.openRegisterScreen.toggle()
                        } label: {
                            Text("Register")
                                .foregroundColor(Color.greenColor)
                        }
                        .fullScreenCover(isPresented: $vm.openRegisterScreen) {
                            RegisterView()
                        }


                        
                        
                        
                        
                    }
                    .padding()
                }
            }
            .fullScreenCover(isPresented: $vm.isLogged) {
                vm.nextView()
            }
          
        
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
