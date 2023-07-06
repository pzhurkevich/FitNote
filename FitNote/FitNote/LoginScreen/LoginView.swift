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
                        .autocorrectionDisabled(true)
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
                    
      
                }.padding(20)
                    .background( RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(Color.secondaryDark)
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                
                
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
            .fullScreenCover(isPresented: $vm.isLogged) {
                switch Constants.currentState {
                case .notLogged:
                   LoginView()
                case .loggedAsSelf:
                    CustomerView()
                case .loggedAsTrainer:
                    TrainerView()
                case .none:
                    OnboardingView()
                case .noInternet:
                    NetworkErrorView()
                case .appRoleNotChoosen:
                    AppRoleView()
                }
            }
            .alert("", isPresented: $vm.showingAlert) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(vm.errorText)
            }
            .hideKeyboardWhenTappedAround()
          
        
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
