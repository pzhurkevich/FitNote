//
//  LoginScreenView.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import SwiftUI

struct LoginScreenView: View {
    
    @StateObject var vm = LoginScreenViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color("mainDark").ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(Color("secondaryDark"))
                    .frame(maxWidth: UIScreen.main.bounds.size.width * 0.85, maxHeight: UIScreen.main.bounds.size.height * 0.65)
                VStack{
                    
                    Image(systemName: "chevron.right.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("mainGreen"))
                        .padding()
                    
                    Text("Sign In")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    TextField("", text: $vm.email, prompt: Text("Email").foregroundColor(.white))
                        .foregroundColor(Color("mainGreen"))
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                        .padding()
                    
                    SecureField("", text: $vm.password, prompt: Text("Password").foregroundColor(.white))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("mainGreen"))
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
                        //                    .padding(.horizontal, 30)
                        //                    .padding(.vertical, 10)
                            .background(Color("mainGreen"))
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
                        NavigationLink {
                            RegisterScreenView()
                        } label: {
                            Text("Register")
                                .foregroundColor(Color("mainGreen"))
                        }
                        
                        
                        
                        
                    }
                    .padding()
                }
            }
            .fullScreenCover(isPresented: $vm.isLogged) {
                EmptyView()
            }
        }
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}
