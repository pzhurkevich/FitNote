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
        Form {
          
            VStack {
                       DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.graphical)
                       Text("Your selected date: \(selectedDate)")
                   }.padding()
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(vm: PlannerViewViewModel())
    }
}
