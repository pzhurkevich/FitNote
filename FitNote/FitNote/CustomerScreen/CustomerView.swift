//
//  CustomerView.swift
//  FitNote
//
//  Created by Pavel on 10.06.23.
//

import SwiftUI

struct CustomerView: View {
    
    @StateObject var vm = CustomerViewViewModel()
    
    
    var body: some View {
        NavigationView {
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
                                    .onChange(of: vm.changeProfileImage, perform: { newValue in
                                        Task {
                                            await vm.addImageToUser()
                                        }
                                    })

                            }
                            
                            .padding()
                            .sheet(isPresented: $vm.openCameraRoll) {
                                ImagePicker(imageUrl: $vm.imageURL, changeProfileImage: $vm.changeProfileImage, sourceType: .photoLibrary)
                            }
                            
                        }
                        
                        .padding(.horizontal, geometry.size.width / 5)
                        .padding(.top, 20)
                        
                        Text("Hello, \(vm.name)!")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("your e-mail: \(vm.email)")
                            .foregroundColor(.white)
                            .padding(8)
                        
                        Spacer()
                        
                        
                    }
                    
                    
                    
                }
                HStack {
                    
                    Button {
                        
                        vm.signOutAppUser()
                        
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left.circle")
                                .foregroundColor(.red)
                            Text("Sign Out")
                        }
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                        .padding(8)
                        .frame(maxWidth:.infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                    }
                    .padding(10)
                    .fullScreenCover(isPresented: $vm.openloginView) {
                        LoginView()
                    }
                    
                    
                    
                    
                    Button {
                        
                        vm.deleteAppUser()
                        
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                            Text("Delete Account")
                        }
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                        .padding(8)
                        .frame(maxWidth:.infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                    }
                    .padding(10)
                    
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    Spacer()
                    
                    
                    
                    Button {
                        //action
                    } label: {
                        NavigationLink(destination: WorkoutView()) {
                            HStack {
                                Text("New workout")
                                    .fontDesign(.rounded)
                                    .fontWeight(.bold)
                                
                                Image(systemName: "chevron.forward")
                                    .fontWeight(.bold)
                            }
                            .tint(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.greenColor)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button {
                        //action
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
                        .padding(.vertical, 20)
                        .background(Color.greenColor)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    
                    Button {
                        //action
                    } label: {
                        HStack {
                            Text("Your statistic")
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                            
                            Image(systemName: "chevron.forward")
                                .fontWeight(.bold)
                        }
                        .tint(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.greenColor)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    
                }
                .padding(.bottom, 30)
            }
        }
        .accentColor(Color.greenColor) //для кнопки "back"
        .task {
            await vm.fetchAppUserinfo()
        }
        
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView()
    }
}
