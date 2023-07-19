//
//  TrainerView.swift
//  FitNote
//
//  Created by Pavel on 19.06.23.
//

import SwiftUI

struct TrainerView: View {
    
    @StateObject var vm = TrainerViewViewModel()
    
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
                    } //.ignoresSafeArea(edges: .bottom)
                    
                    VStack {
                        ZStack(alignment: .center) {
                            
                            
                            Circle()
                                .foregroundColor(Color.secondaryDark)
                            

                            ZStack(alignment: .bottomTrailing) {
                                
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
                                
                                Button() {
                         
                                    vm.openCameraRoll = true
                                    
                                } label : {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .scaledToFit()
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
                            
                            Text("Hello, \(vm.name)!")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text("your e-mail: \(vm.email)")
                                .foregroundColor(.white)
                                .padding(8)
                            
                            
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
                          
                            Divider()
                                .background(.white)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            HStack {
                                Text("Today:")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.greenColor)
                                    .padding(.leading, 20)
                                
                                Spacer()
                            }
                            .padding([.top, .bottom], 20)
                            if vm.todayClients.isEmpty {
                                Spacer()
                                Text("There are no clients today")
                                    .foregroundColor(.red)
                                    .font(.title2.bold())
                                Spacer()
                            } else {
                                ScrollView {
                                    
                                    VStack {
                                        
                                        ForEach(vm.todayClients) { client in
                                            
                                            HStack {
                                                
                                                Text(client.time.stringTime())
                                                    .font(.title3.bold())
                                                    .foregroundColor(.darkColor)
                                                    .padding(10)
                                                    .background(Color.greenColor)
                                                    .padding(.leading, 20)
                                                
                                                VStack(alignment: .leading) {
                                                    
                                                    Text(client.client.name)
                                                        .foregroundColor(.white)
                                                        .font(.title3.bold())
                                                    
                                                    Spacer()
                                                    
                                                    HStack() {
                                                        Text("Last workout:")
                                                            .font(.system(size: 12))
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                        
                                                        Text(vm.lastWorkouts[client.client.id] ?? "-")
                                                            .foregroundColor(.greenColor)
                                                            .font(.system(size: 12))
                                                            .lineLimit(2)
                                                            .padding(.leading, 5)
                                                    }
                                                    
                                                }
                                                .padding(.leading, 10)
                                                .padding(.trailing, 5)
                                                
                                                Spacer()
                                                
                                                AsyncImage(url: URL(string: vm.updatedImages[client.client.id] ?? "")) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 50, height: 50)
                                                        .foregroundColor(.white)
                                                        .overlay(Circle()
                                                            .stroke(Color.greenColor, lineWidth: 2))
                                                        .clipShape(Circle())
                                                    
                                                    
                                                } placeholder: {
                                                    Image("user")
                                                        .renderingMode(.template)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 50, height: 50)
                                                    
                                                        .foregroundColor(.white)
                                                    
                                                        .overlay(Circle()
                                                            .stroke(Color.greenColor, lineWidth: 2))
                                                        .clipShape(Circle())
                                                }
                                                .padding(.trailing, 30)
                                            }
                                            
                                            
                                            Divider()
                                                .background(.white)
                                                .padding(.horizontal, 20)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        
                    }
                    
                }
                
            }
        .accentColor(Color.greenColor) //для кнопки "back"
        .task {
            await vm.fetchAppUserinfo()
            await vm.fetchTasks()
            await vm.getClientsData()
        }
    }
}

struct TrainerView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerView()
    }
}
