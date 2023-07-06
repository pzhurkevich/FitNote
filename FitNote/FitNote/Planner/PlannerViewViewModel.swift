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
    @Published var currentMonth: Int = 0 {
        didSet {
            currentDate = getCurrentMonth()
            fillDates()
        }
    }
    @Published var days: [String] = []

   
    @Published var newClientName = ""
    
    @Published var tasks: [ClientTaskData] = []
    @Published var taskToDisplay: [ClientTask] = []
    @Published var daysInCalendar: [DateInCalendar] = []
    
    @Published var isShown = false
    @Published var showAlert = false
    
// MARK:  - Methods -
    init() {
        fillDates()
        fillWeekDays()
    }
    
    func fillWeekDays() {
        days = Calendar.current.shortWeekdaySymbols
        if Calendar.current.firstWeekday != 1 {
            days = Calendar.current.shortWeekdaySymbols
            if let sunday = Calendar.current.shortWeekdaySymbols.first {
                days.removeFirst()
                days.append(sunday)
            }
        }
        
    }

    func fillDates() {
            
            let currentMonth = getCurrentMonth()
        var emptyDays: [DateInCalendar] = []
            
            var monthDays = currentMonth.getAllDates().compactMap { date -> DateInCalendar in
                let day = calendar.component(.day, from: date)
                return DateInCalendar(day: day, date: date)
            }
        var firstWeekday = calendar.component(.weekday, from: monthDays.first?.date ?? Date())
        firstWeekday = (firstWeekday == 1) ? 8 : firstWeekday

        if Calendar.current.firstWeekday == 1 {
            emptyDays = (1..<firstWeekday).map { _ in DateInCalendar(day: 0, date: Date()) }

        } else {
            emptyDays = (1..<firstWeekday-1).map { _ in DateInCalendar(day: 0, date: Date()) }

        }
        monthDays.insert(contentsOf: emptyDays, at: 0)
        daysInCalendar = monthDays
        }

    
    func getCurrentMonth() -> Date {

        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else { return Date() }
        return currentMonth
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
        createNotification(name: client.clientName, date: client.time)
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
    
    func deleteClient(indexSet: IndexSet, allTask: ClientTaskData) {
        let index = indexSet[indexSet.startIndex]
        let taskToDelete = allTask.task[index]
        let updatedTasks = allTask.task.filter { $0 != taskToDelete }
        if updatedTasks.isEmpty {
            fireBaseManager.deleteOneClientTask(docId: allTask.id)
            tasks = tasks.filter { $0.id != allTask.id }
        } else {
            let updatedClientTaskData = ClientTaskData(id: allTask.id, task: updatedTasks, taskDate: allTask.taskDate)
            tasks = tasks.filter { $0.id != allTask.id }
            tasks.append(updatedClientTaskData)
            tasks = tasks.filter { !$0.task.isEmpty }
            Task { [weak self] in
                guard let self = self else {return}
                await fireBaseManager.saveClientsPlanner(allTasks: tasks)
            }
        }
    }
    
    func requestAuthorization() {
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {[weak self] success, error in
             guard let self = self else {return}
             if success {
                 print("permissions granted")
             } else if let error = error {
                 print(error.localizedDescription)
             }
             DispatchQueue.main.async {
                 self.isShown.toggle()
             }
         }
     }

     
     func createNotification(name: String, date: Date) {
         let content = UNMutableNotificationContent()
         content.title = "Workout reminder"
         content.subtitle = "Workour with \(name) tomorrow."
         content.sound = UNNotificationSound.default
         let timeInterval = date.timeIntervalSinceNow
         var reminderTime = timeInterval - 86400
         reminderTime = (timeInterval < 86400) ? 3 : reminderTime
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderTime, repeats: false)

         let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

         UNUserNotificationCenter.current().add(request)
     }
}
