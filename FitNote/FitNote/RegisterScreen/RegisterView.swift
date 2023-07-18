//
//  RegisterView.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var vm = RegisterViewViewModel()
    @FocusState private var textIsFocused: Bool
    
    var body: some View {
            ZStack {
                
               Color.darkColor.ignoresSafeArea()
                
                VStack (spacing: 0){
                    
                    Image(systemName: "chevron.up.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.greenColor)
                        .padding()
                    
                    Text("Registration")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading) {
                        TextField("name", text: $vm.name)
                            .focused($textIsFocused)
                            .autocorrectionDisabled(true)
                            .foregroundColor(Color.greenColor)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(uiColor: .white), lineWidth: 2)
                            }
                            .padding([.top, .leading, .trailing], 18)
                        Text(vm.nameAlert)
                            .foregroundColor(.red)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption)
                            .padding(.leading, 40)
                    }
                    
                    VStack(alignment: .leading) {
                        TextField("email", text: $vm.email)
                            .focused($textIsFocused)
                            .foregroundColor(Color.greenColor)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(uiColor: .white), lineWidth: 2)
                            }
                            .padding([.top, .leading, .trailing], 18)
                        Text(vm.emailAlert)
                            .foregroundColor(.red)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption)
                            .padding(.leading, 40)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            if vm.showPassword {
                                TextField ("password", text: $vm.password)
                                    .focused($textIsFocused)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(Color.greenColor)
                            } else {
                                SecureField("password", text: $vm.password)
                                    .focused($textIsFocused)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(Color.greenColor)
                            }
                            Button {
                                vm.showPassword.toggle()
                               
                            } label: {
                                Image(systemName: vm.showPassword ? "eye" : "eye.slash")
                                    .resizable()
                                    .foregroundColor(.greenColor)
                                    .frame(width: 30, height: 20)
                                    .padding(.trailing, 20)
                            }
                        }
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                        .padding([.top, .leading, .trailing], 18)
                        
                        
                        Text(vm.passwordAlert)
                            .foregroundColor(.red)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption)
                            .padding(.leading, 40)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            
                            if vm.showConfirm {
                                TextField("confirm password", text: $vm.passwordConfirm)
                                    .focused($textIsFocused)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(Color.greenColor)
                            } else {
                                SecureField("confirm password", text: $vm.passwordConfirm)
                                    .focused($textIsFocused)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(Color.greenColor)
                            }
                            Button {
                                vm.showConfirm.toggle()
                               
                            } label: {
                                Image(systemName: vm.showConfirm ? "eye" : "eye.slash")
                                    .resizable()
                                    .foregroundColor(.greenColor)
                                    .frame(width: 30, height: 20)
                                    .padding(.trailing, 20)
                            }

                        }
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                    .padding([.top, .leading, .trailing], 18)
                        
                        Text(vm.passwordConfirmAlert)
                            .foregroundColor(.red)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption)
                            .padding(.leading, 40)
                    }
                    
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
                    .disabled(!vm.registrationAllowed)
                    .opacity(vm.registrationAllowed ? 1 : 0.6)

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
           .onTapGesture {
               textIsFocused = false
           }
    }
}

struct RegisterScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
