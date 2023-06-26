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
        ZStack {
            
            Color.darkColor.ignoresSafeArea()
            
            VStack(spacing: 35) {
                
                
                
                
                HStack(spacing: 20){
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text(vm.displayData()[1])
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text(vm.displayData()[0])
                            .font(.title.bold())
                            .foregroundColor(.white)
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
                            .foregroundColor(Color.greenColor)
                        
                    }
                }
                
                //тут даты
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                    ForEach(vm.fillDates()) { item in

                        VStack {
                            if item.day != 0 {
                                if let task = vm.tasks.first(where: { task in
                                    return vm.checkDay(date1: task.taskDate, date2: item.date)
                                }) {
                                    Text("\(item.day)")
                                        .font(.title3.bold())
                                        .foregroundColor(vm.checkDay(date1: task.taskDate, date2: vm.currentDate) ? .black : .white)
                                        .frame(maxWidth: .infinity)
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .fill(vm.checkDay(date1: task.taskDate, date2: vm.currentDate) ? .black : Color.red)
                                        .frame(width: 8, height: 8)
                                    
                                } else {
                                    Text(item.day != 0 ? "\(item.day)" : "")
                                        .font(.title3.bold())
                                        .foregroundColor(vm.checkDay(date1: item.date, date2: vm.currentDate) ? .black : .white)
                                        .frame(maxWidth: .infinity)
                                    
                                    
                                    Spacer()
                                }
                                
                            }
                            
                           
                        }
                        .padding(.vertical, 8)
                        
                        .background(
                        Capsule()
                            .fill(Color.greenColor)
                            .padding(.horizontal, 8)
                            .opacity(vm.checkDay(date1: item.date, date2: vm.currentDate) ? 1 : 0)
                        )
                        
                        .onTapGesture {
                            vm.currentDate = item.date
                        }
                       // .frame(height: 60, alignment: .top)
                        
                    }
                }
                
                
                Spacer()
            }.onChange(of: vm.currentMonth) { newValue in
                vm.currentDate = vm.getCurrentMonth()
        }
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
        
        return period.compactMap { day -> Date in
            guard let datesForCalendar = calendar.date(byAdding: .day, value: day - 1, to: startDate) else { return Date()}
            return datesForCalendar
        }
    }
}
