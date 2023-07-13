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
        NavigationView {
            ZStack {
                
                Color.darkColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    HStack(spacing: 20){
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text(vm.currentDate.stringYear())
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text(vm.currentDate.stringEnMonth())
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 10)
                        
                        Spacer()
                        //кнопки листать месяцы
                        Button {
                            withAnimation {
                                vm.currentMonth = 0
                            }
                            
                        } label: {
                            Text("today")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.greenColor, lineWidth: 1)
                                )
                            
                        }
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
                    
                    Divider()
                        .background(.white)
                        .padding(.vertical, 10)
                    
                    
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
                        ForEach(vm.daysInCalendar) { item in
                            
                            VStack {
                                if item.day != 0 {
                                    if let task = vm.taskInDate(dateInCalendar: item.date) {
                                        Text("\(item.day)")
                                            .font(.title3.bold())
                                            .foregroundColor(task.taskDate.checkDay(date: vm.currentDate) ? .black : .white)
                                            .frame(maxWidth: .infinity)
                                        
                                        Spacer()
                                        
                                        Circle()
                                            .fill(task.taskDate.checkDay(date: vm.currentDate)  ? .black : Color.red)
                                            .frame(width: 8, height: 8)
                                        
                                    } else {
                                        Text(item.day != 0 ? "\(item.day)" : "")
                                            .font(.title3.bold())
                                            .foregroundColor(item.date.checkDay(date: vm.currentDate) ? .black : .white)
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
                                    .opacity(item.date.checkDay(date: vm.currentDate) ? 1 : 0)
                            )
                            
                            .onTapGesture {
                                vm.currentDate = item.date
                            }
                            .frame(height: 40, alignment: .top)
                            
                        }
                        
                    }
                    
                    VStack(spacing: 8) {
                        
                        Divider()
                            .background(.white)
                            .padding(.vertical, 10)
                        
                        Text("Clients")
                            .foregroundColor(.greenColor)
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        
                        
                        if let task = vm.taskInDate(dateInCalendar: vm.currentDate) {
                            
                            List {
                                ForEach(task.task) { client in
                                    
                                    HStack(spacing: 10) {
                                        Text(client.time, style: .time)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .padding(.leading, 10)
                                        
                                        Text(client.clientName)
                                            .font(.system(size: 18))
                                            .font(.title2.bold())
                                            .foregroundColor(.greenColor)
                                    }
                                    .padding(10)
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundColor(.secondaryDark)
                                            .padding([.top, .bottom], 5)
                                            .padding(.horizontal, 20)
                                            .listRowSeparator(.hidden))
                                    .swipeActions(allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            vm.deleteClient(allTask: task, client: client)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .background(Color.darkColor)
                            .scrollContentBackground(.hidden)
      
                            Spacer()
                        } else {
                            Text("No clients at this day")
                                .foregroundColor(Color.pink)
                            Spacer()
                        }
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Clients Planner")
                            .font(.title)
                            .foregroundColor(.greenColor)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task {
                                await vm.checkCurrentAuthorizationSetting()
                            }
                        } label: {
                            Image(systemName: "plus")
                            
                                .foregroundColor(.greenColor)
                        }
                    }
                }
                .sheet(isPresented: $vm.isShown) {
                    CustomDatePicker(vm: vm)
                }
                .task {
                    await vm.fetchTasksToPlanner()
                }
                .alert("", isPresented: $vm.showAlert) {
                    Button("Ok", role: .cancel) {
                        vm.isShown.toggle()
                    }
                    
                } message: {
                    Text("You will receive notification about client workout the day before it")
                }
        }
    }
}

struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
        Planner()
    }
}



