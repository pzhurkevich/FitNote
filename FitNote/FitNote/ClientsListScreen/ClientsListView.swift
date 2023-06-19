//
//  ClientsListView.swift
//  FitNote
//
//  Created by Pavel on 19.06.23.
//

import SwiftUI

struct ClientsListView: View {
    
    @StateObject var vm = ClientsListViewViewModel()
    
    var body: some View {
        
        ZStack {
          
            Color.darkColor.ignoresSafeArea()
            
            VStack {
                
                if vm.clients.isEmpty {
                 Text("Add new clients using button")
                } else {
                    
                    List(vm.clients, id: \.id) { client in
                        
                        NavigationLink {
                            CustomerView(clientData: client)
                        } label: {
                            
                            HStack(spacing: 20) {
                                
                                
                                
                                HStack(spacing: 20) {
                                    Image("user")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 70)
                                        .cornerRadius(5)
                                    
                                    
                                    
                                    
                                    Text(client.name)
                                        .font(Font.title)
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.5)
                                    
                                }
                                
                                
                            }
                            // .buttonStyle(PlainButtonStyle())
                            
                        }
                        .padding(5)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.secondaryDark)
                                .padding([.top, .bottom], 10)
                                .listRowSeparator(.hidden)
                        )
                        
                        
                        //end list
                    }
                    .blendMode(vm.clients.isEmpty ? .destinationOver: .normal)
                    .background(Color.darkColor)
                    .scrollContentBackground(.hidden)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Your clients")
                                .font(.largeTitle)
                                .foregroundColor(.greenColor)
                        }
                        
                    }
                    .toolbarBackground(Color.darkColor)
                }
                    
                Button {
                    vm.showingAlert.toggle()
                } label: {
                    HStack {
                        Text("New Client")
                            .font(.system(size: 20))
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                        
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                    }
                    .tint(.black)
                   // .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Color.greenColor)
                    .clipShape(Capsule())
                }.padding(.bottom, 20)
                
            }
        }
        .alert("Add client", isPresented: $vm.showingAlert) {
            TextField("name", text: $vm.newClientName)
            Button("Add", action: vm.addNewClient)
              } message: {
                  Text("Enter only client name to continue")
              }
              .task {
                  await vm.fetchClients()
              }
    }
}

struct ClientsListView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsListView()
    }
}
