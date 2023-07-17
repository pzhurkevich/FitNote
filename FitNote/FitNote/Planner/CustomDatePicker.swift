//
//  CustomDatePicker.swift
//  FitNote
//
//  Created by Pavel on 27.06.23.
//

import SwiftUI

struct CustomDatePicker: View {
    @ObservedObject var vm: PlannerViewViewModel
    @FocusState var textIsFocused: Bool
    
    var body: some View {
        ZStack {
            
            Color.darkColor.ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Choose Date:")
                        .foregroundColor(.greenColor)
                        .font(.title2.bold())
                        .padding(.leading, 20)
                    Spacer()
                }
                Divider()
                    .background(.white)
                    .padding(.horizontal, 20)
                
                DatePicker("", selection: $vm.selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .colorScheme(.dark)
                    .accentColor(Color.greenColor)
                
                if !vm.clients.isEmpty {
                Divider()
                    .background(.white)
                    .padding(.horizontal, 20)
                
                HStack {
                    Text("Choose Client:")
                        .foregroundColor(.greenColor)
                        .font(.title2.bold())
                        .padding(.leading, 20)
                    Spacer()
                }
                
                HStack {
                    Text("Existing client")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Picker("Client:", selection: $vm.selectedClient) {
                        ForEach(vm.clients) { client in
                            Text(client.name).tag(client)
                        }
                    }
                    .accentColor(Color.greenColor)
                    .pickerStyle(.menu)
                    
                }
                .padding(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(uiColor: .white), lineWidth: 2)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                
                Button {
                    
                    vm.addExistingClientToPlanner()
                    
                } label: {
                    
                    Text("Add existing")
                        .foregroundColor(.black)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .padding(8)
                        .padding(.horizontal, 20)
                        .background(Color.greenColor)
                        .clipShape(Capsule())
                }
                .padding(10)
                .padding(.bottom, 10)
                
            }
           
                
                
                
                VStack {
                    Divider()
                        .background(.white)
                        .padding(.horizontal, 20)
                    HStack {
                        Text("Create a new Client:")
                            .foregroundColor(.greenColor)
                        .font(.title2.bold())
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }
             
                
                VStack {
                    TextField("new client", text: $vm.newClientName)
                        .foregroundColor(Color.greenColor)
                        .focused($textIsFocused)
                        .onChange(of: textIsFocused) { isFocused in
                            vm.emptyName = false
                                    }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                    if vm.emptyName {
                        Text(vm.nameErrorText.rawValue)
                            .foregroundColor(.red)
                    }
                    
                }
                .padding(.horizontal, 20)
              
                    
                Button {
                   vm.addNewClientToPlanner()
                } label: {
                    
                    Text("Add new")
                        .foregroundColor(.black)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .padding(8)
                        .padding(.horizontal, 20)
                        .background(Color.greenColor)
                        .clipShape(Capsule())
                }.padding(10)
                   }
       
               
            
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(vm: PlannerViewViewModel())
    }
}
