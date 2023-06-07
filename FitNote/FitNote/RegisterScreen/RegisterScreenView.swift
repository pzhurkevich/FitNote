//
//  RegisterScreenView.swift
//  FitNote
//
//  Created by Pavel on 8.06.23.
//

import SwiftUI

struct RegisterScreenView: View {
    
    @StateObject var vm = RegisterScreenViewModel()
    
    var body: some View {
       ZStack {
            
            Color("mainDark").ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color("secondaryDark"))
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.85, maxHeight: UIScreen.main.bounds.size.height * 0.85)
            VStack{
                
                Image(systemName: "chevron.up.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("mainGreen"))
                    .padding()
                
                Text("Registration")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                TextField("Name", text: $vm.name, prompt: Text("").foregroundColor(.white))
                    .foregroundColor(Color("mainGreen"))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(uiColor: .white), lineWidth: 2)
                    }
                    .padding()
                
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
                    vm.register()
                } label: {
                   
                    Text("Create Account")
                        .foregroundColor(.black)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                    .background(Color("mainGreen"))
                    .clipShape(Capsule())
                }
                
                .padding([.horizontal, .vertical], 16)
                
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width * 0.85, maxHeight: UIScreen.main.bounds.size.height * 0.65)
        }
       .fullScreenCover(isPresented: $vm.isRegistered) {
           EmptyView()
   }
       .navigationBarHidden(true)
    }
}

struct RegisterScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreenView()
    }
}
