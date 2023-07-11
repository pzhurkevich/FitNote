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
        
        NavigationView {
            ZStack {
                
                Color.darkColor.ignoresSafeArea()
                
                VStack {
                    
                    if vm.clients.isEmpty {
                        Text("Add new client")
                            .font(.title)
                            .foregroundColor(.white)
                    } else {
                        
                        List {
                            
                            ForEach(vm.clients, id: \.id) { client in
                                NavigationLink {
                                    ClientView(vm: ClientViewViewModel(clientData: client))
                                } label: {
                                    
                                        HStack(spacing: 20) {
                                            
                                            
                                            AsyncImage(url: URL(string: client.imageURL)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .foregroundColor(.white)
                                                    .overlay(Circle()
                                                        .stroke(Color.greenColor, lineWidth: 10))
                                                    .clipShape(Circle())
                                                
                                                
                                            } placeholder: {
                                                Image("user")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                
                                                    .foregroundColor(.white)
                                                
                                                    .overlay(Circle()
                                                        .stroke(Color.greenColor, lineWidth: 10))
                                                    .clipShape(Circle())
                                            }
                                            
                                            Text(client.name)
                                                .font(Font.title)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.5)
                                        }
                                }
                                .padding(5)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.secondaryDark)
                                        .padding([.top, .bottom], 10)
                                        .listRowSeparator(.hidden))
                                .swipeActions(allowsFullSwipe: false) {
                                  Button(role: .destructive) {
                                      vm.deleteClient(client: client)
                                  } label: {
                                    Label("Delete", systemImage: "trash")
                                  }
                                }
                            }
                            //end list
                        }
                        .blendMode(vm.clients.isEmpty ? .destinationOver: .normal)
                        .background(Color.darkColor)
                        .scrollContentBackground(.hidden)
                        
                        
                    }
                      
                }
            }.navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Your clients")
                            .font(.title)
                            .foregroundColor(.greenColor)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            vm.showingAlert.toggle()
                        } label: {
                            Image(systemName: "plus")
                            
                                .foregroundColor(.greenColor)
                        }
                    }
                }
               .toolbarBackground(Color.darkColor)
            .alert("Add Client", isPresented: $vm.showingAlert) {
                TextField("name", text: $vm.newClientName)
                    .disableAutocorrection(true)
                Button("Add", action: vm.addNewClient)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter only client name to continue")
            }
            .task {
                await vm.fetchClients()
            }
        }
    }
}

struct ClientsListView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsListView()
    }
}
