//
//  DatePicker.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import SwiftUI

struct DatePicker: View {
    
    @StateObject var vm = PlannerViewViewModel()
    
   // @Binding var currentDate: Date
    //let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        VStack(spacing: 35) {
            
            
            
            
            HStack(spacing: 20){
                
                VStack(alignment: .leading, spacing: 10){
                    Text(vm.displayData()[1])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(vm.displayData()[0])
                        .font(.title.bold())
                }
                
                Spacer()
             //кнопки листать месяцы
                
                Button {
                    withAnimation {
                        vm.currentMonth -= 1
                    }
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                    
                }
                
                Button {
                    
                    withAnimation {
                        vm.currentMonth += 1
                    }
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                    
                }
                
                
            }
            .padding()
            //дни в месяце
            HStack(spacing: 0) {
                ForEach(vm.days, id: \.self) {day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                    
                }
            }
            
            //тут даты
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                ForEach(vm.fillDates()) { item in
                    Text("\(item.day)")
                        .font(.title3.bold())
                    
                }
            }
            
            
            Spacer()
        }.onChange(of: vm.currentMonth) { newValue in
            vm.currentDate = vm.getCurrentMonth()
        }
    }
}

struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker()
    }
}


extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) else {return []}
        
        guard var period = calendar.range(of: .day, in: .month, for: startDate) else { return [] }
        period.removeLast()
        
        return period.compactMap { day -> Date in
            guard let datesForCalendar = calendar.date(byAdding: .day, value: day == 1 ? 0 : day, to: startDate) else { return Date()}
            return datesForCalendar
        }
    }
}
