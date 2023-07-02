//
//  PlannerViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import Foundation
import UIKit

final class PlannerViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    let calendar = Calendar.current
    
    @Published var currentDate: Date = Date()
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Int = 0
    @Published var days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

   
    @Published var newClientName = ""
    
    @Published var tasks: [ClientTaskData] = []
    @Published var taskToDisplay: [ClientTask] = []
    
    
    @Published var isShown = false
    @Published var showAlert = false
    
// MARK:  - Methods -
    
    
    func getCurrentMonth() -> Date {

        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else { return Date() }
        return currentMonth
    }
    
    func fillDates() -> [DateInCalendar] {
        
        let currentMonth = getCurrentMonth()
        
        let monthDays = currentMonth.getAllDates().compactMap { date -> DateInCalendar in
            
            let day = calendar.component(.day, from: date)
            return DateInCalendar(day: day, date: date)
        }
        let firstWeekday = calendar.component(.weekday, from: monthDays.first?.date ?? Date())
        let emptyDays = (1..<firstWeekday).map { _ in
            return DateInCalendar(day: 0, date: Date())
        }
        
        return emptyDays + monthDays
    }
    
    func addClientToPlanner() {
        let id = UUID().uuidString
        let idData = UUID().uuidString
        
        guard !newClientName.isEmpty else {
            showAlert.toggle()
            return
            
        }
        
        
        
        let client = ClientTask(id: id, clientName: newClientName, time: selectedDate)
        var taskToDisplay: [ClientTask] = []
        
        if tasks.isEmpty {
           
            taskToDisplay.append(client)
            tasks.append(ClientTaskData(id: idData, task: taskToDisplay, taskDate: selectedDate))
        } else {
            
            for i in 0..<tasks.count {
                var clientTaskData = tasks[i]

                let componentsClient = clientTaskData.taskDate.getDateComponents()
                let componentsDate = selectedDate.getDateComponents()
                
                if componentsClient == componentsDate {
                    clientTaskData.addTask(newClient: client)
                  tasks[i] = clientTaskData
                } else {

                    taskToDisplay.append(client)
                    tasks.append(ClientTaskData(id: idData, task: taskToDisplay.sorted(), taskDate: selectedDate))
                }
            }
            
        }
        
        Task { [weak self] in
            guard let self = self else {return}
            await fireBaseManager.saveClientsPlanner(allTasks: tasks)
        }
       isShown.toggle()
    }
    
    func fetchTasksToPlanner() async {

            let clientsTasksFromServer  =  await self.fireBaseManager.fetchClientsToPlanner()
          
            await MainActor.run {
                self.tasks = clientsTasksFromServer
            }
    }
    
    func taskInDate(dateInCalendar: Date) -> ClientTaskData? {
        return tasks.first(where: { task in
            return task.taskDate.checkDay(date: dateInCalendar)
        })
    }
    
    
}
