//
//  CustomDatePicker.swift
//  FitNote
//
//  Created by Pavel on 27.06.23.
//

import SwiftUI

struct CustomDatePicker: View {
    @ObservedObject var vm: PlannerViewViewModel
    @State var selectedDate = Date()
    
    var body: some View {
        ZStack {
            
            Color.darkColor.ignoresSafeArea()
            
            VStack {
              
                VStack {
                  
                    DatePicker("", selection: $vm.selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .colorScheme(.dark)
                        .accentColor(Color.greenColor)
        
                        
                    
                    TextField("client", text: $vm.newClientName, prompt: Text("new client").foregroundColor(.white))
                        .foregroundColor(Color.greenColor)
                        .padding(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(uiColor: .white), lineWidth: 2)
                        }
                        .padding([.vertical, .horizontal], 20)
                        
                       
                       }.padding()
                Button {
                   
                   vm.addClientToPlanner()
                    vm.isShown.toggle()
                    
                } label: {
                    
                    Text("Add")
                        .foregroundColor(.black)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
    //                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .padding(.horizontal, 20)
                        .background(Color.greenColor)
                        .clipShape(Capsule())
                }.padding(5)
            }
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(vm: PlannerViewViewModel())
    }
}
