//
//  Planner.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import SwiftUI

struct Planner: View {
    
    @StateObject var vm = PlannerViewViewModel()
    
    var body: some View {
        ZStack {
            
            Color.darkColor.ignoresSafeArea()
            
            VStack(spacing: 20) {
        
            
                
                HStack {
        
                    Text("Clients Planner")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                        .padding()
                    
                        Spacer()
                    //кнопка добавить клиента
                            Button {
                                vm.isShown.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.greenColor)
                            }
                            .padding()

                        
                }
                
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
                            .foregroundColor(.greenColor)
                        
                    }
                    
                    Button {
                        
                        withAnimation {
                            vm.currentMonth += 1
                        }
                        
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.greenColor)
                    }
                    
                    
                }
                .padding([.leading, .trailing, .top], 10)
                //дни в месяце
                HStack(spacing: 0) {
                    ForEach(vm.days, id: \.self) { day in
                        
                        Text(day)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.greenColor)
                        
                    }
                }
                
                //тут даты
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
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
                        .frame(height: 40, alignment: .top)
                        
                    }
                    
                }
                
                VStack(spacing: 8) {
                    Text("Clients")
                        .foregroundColor(.greenColor)
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                    
                    
                    if let task = vm.tasks.first(where: { task in
                        return vm.checkDay(date1: task.taskDate, date2: vm.currentDate)
                    }) {
                        
                       ScrollView {
                           ForEach(task.task.sorted()) { task in
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(task.time, style: .time)
                                    .foregroundColor(.white)
                                    
                                    Text(task.clientName)
                                        .font(.title2.bold())
                                        .foregroundColor(.greenColor)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                  Color.secondaryDark
                                      .opacity(0.5)
                                      .cornerRadius(20)
                                )
                            }
                        }
                        
                        Spacer()
                    } else {
                        Text("No clients at this day")
                            .foregroundColor(Color.pink)
                        Spacer()
                    }
                }
            }.onChange(of: vm.currentMonth) { newValue in
                vm.currentDate = vm.getCurrentMonth()
            }

           
        }
        .sheet(isPresented: $vm.isShown) {
            CustomDatePicker(vm: vm)
        }
       
        .task {
            await vm.fetchTasksToPlanner()
        }
    }
}

struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
        Planner()
    }
}



