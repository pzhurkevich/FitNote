//
//  ClientView.swift
//  FitNote
//
//  Created by Pavel on 20.06.23.
//

import SwiftUI

struct ClientView: View {
    
    @ObservedObject var vm : ClientViewViewModel
    
    var body: some View {
        
 
            ZStack {
                
                Color.darkColor.ignoresSafeArea()
                
                
                GeometryReader { geometry in
                    
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .frame(maxHeight: geometry.size.height * 0.85)
                            .foregroundColor(Color.secondaryDark)
                            .specificCornersRadius(radius: 30, coners: [.topLeft, .topRight])
                    } .ignoresSafeArea(edges: .bottom)
                    
                    VStack {
                        ZStack(alignment: .center) {
                            
                            
                            Circle()
                                .foregroundColor(Color.secondaryDark)
                            
                            
                            Button {
                                
                                vm.openCameraRoll = true
                                
                                
                                
                            } label: {
                                
                                
                                AsyncImage(url: vm.imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                                        .foregroundColor(.white)
                                        .overlay(Circle()
                                            .stroke(Color.greenColor, lineWidth: 10))
                                        .clipShape(Circle())
                                    
                                    
                                } placeholder: {
                                    Image("user")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                                    
                                        .foregroundColor(.white)
                                    
                                    
                                        .overlay(Circle()
                                            .stroke(Color.greenColor, lineWidth: 10))
                                        .clipShape(Circle())
                                }
                            }
                            
                            .padding()
                            .sheet(isPresented: $vm.openCameraRoll) {
                                ImagePicker(imageUrl: $vm.imageURL, changeProfileImage: $vm.changeProfileImage, sourceType: .photoLibrary)
                            }
                            
                        }
                        
                        .padding(.horizontal, geometry.size.width / 5)
                        .padding(.top, 20)
                        
                        VStack(spacing: 0) {
                            
                            
                            VStack {
                                
                                Text(vm.clientData.name)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        
                                        Image("inst")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.greenColor)
                                            .frame(width: 30, height: 30)
                                        
                                        
                                        
                                        if vm.instInEditMode {
                                            TextField("instagram", text: $vm.inst).textFieldStyle(RoundedBorderTextFieldStyle())
                                                .padding(.leading, 5)
                                                .font(.system(size: 20))
                                                .autocapitalization(.words)
                                                .disableAutocorrection(true)
                                        } else {
                                            Text(vm.inst)
                                                .font(.system(size: 20))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            vm.instInEditMode.toggle()
                                            vm.updateClientInfo()
                                        }) {
                                            Text(vm.instInEditMode ? "Done" : "Edit")
                                                .font(.system(size: 20))
                                                .fontWeight(.light)
                                                .foregroundColor(.greenColor)
                                        }
                                    }
                                    
                                    HStack {
                                        
                                        Image(systemName: "phone")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.greenColor)
                                            .frame(width: 30, height: 30)
                                        
                                        
                                        
                                        if vm.phoneInEditMode {
                                            TextField("phone", text: $vm.phone).textFieldStyle(RoundedBorderTextFieldStyle())
                                                .padding(.leading, 5)
                                                .font(.system(size: 20))
                                                .autocapitalization(.words)
                                                .keyboardType(.phonePad)
                                                .disableAutocorrection(true)
                                        } else {
                                            Text(vm.phone)
                                                .font(.system(size: 20))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                        }
                                        
                                        Spacer()
                                        Button(action: {
                                            vm.phoneInEditMode.toggle()
                                            vm.updateClientInfo()
                                        }) {
                                            Text(vm.phoneInEditMode ? "Done" : "Edit")
                                                .font(.system(size: 20))
                                                .fontWeight(.light)
                                                .foregroundColor(.greenColor)
                                        }
                                    }
                                    
                                }
                                .padding(.horizontal, 30)
                            }
                            
                            
                            
                            
                            Divider()
                                .background(.white)
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                            
                            
                            VStack(spacing: 20) {
                                
                                Spacer()
                                
                                NavigationLink {
                                    WorkoutView(vm: WorkoutViewViewModel(clientData: vm.clientData))
                                } label: {
                                    HStack {
                                        Text("Workout")
                                            .fontDesign(.rounded)
                                            .fontWeight(.bold)
                                        
                                        Image(systemName: "chevron.forward")
                                            .fontWeight(.bold)
                                    }
                                    .tint(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.greenColor)
                                    .clipShape(Capsule())
                                }
                                .padding(.horizontal, 20)
                                
                                NavigationLink {
                                    HistoryView(vm: HistoryViewViewModel(clientData: vm.clientData))
                                } label: {
                                    HStack {
                                        Text("Workouts history")
                                            .fontDesign(.rounded)
                                            .fontWeight(.bold)
                                        
                                        Image(systemName: "chevron.forward")
                                            .fontWeight(.bold)
                                    }
                                    .tint(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.greenColor)
                                    .clipShape(Capsule())
                                }
                                .padding(.horizontal, 20)
                                
                                Button {
                                    //action
                                } label: {
                                    HStack {
                                        Text("Client statistic")
                                            .fontDesign(.rounded)
                                            .fontWeight(.bold)
                                        
                                        Image(systemName: "chevron.forward")
                                            .fontWeight(.bold)
                                    }
                                    .tint(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.greenColor)
                                    .clipShape(Capsule())
                                }
                                .padding(.horizontal, 20)
                                
                                Spacer()
                                
                            }.padding(.bottom, 10)
                            
                        }
                        
                    }
                    
                }
                
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(Color.greenColor) //для кнопки "back"
            .onAppear {
                vm.loadClientInfo()
        }
        
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView(vm: ClientViewViewModel(clientData: Client()))
    }
}
