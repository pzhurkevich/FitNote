//
//  PlannerViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import Foundation
import UIKit
import UserNotifications

final class PlannerViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    let calendar = Calendar.current
    let notificationCenter = UNUserNotificationCenter.current()
    
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
        
        Task {
            await fireBaseManager.saveClientsPlanner(allTasks: tasks)
        }
        
        createNotification(client: client)
        
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
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [taskToDelete.id])
        
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
    
    
    
    func checkCurrentAuthorizationSetting() async {
        
        let currentSettings = await notificationCenter.notificationSettings()
        
        switch currentSettings.authorizationStatus {
        case .notDetermined:
            await requestAuthorization()
        default:
           await MainActor.run {
                self.isShown.toggle()
            }
        }
 
    }
    
    
    
    
    func requestAuthorization() async {
        
        do {
            let result = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            if result {
                await MainActor.run {
                    self.showAlert.toggle()
                }
            } else {
                await MainActor.run {
                    self.isShown.toggle()
                }
            }
        } catch {
            print(error)
        }
        
    }

     
    func createNotification(client: ClientTask) {
        
        let timeInterval = client.time.timeIntervalSinceNow
        let reminderTime = timeInterval - 86400
        
        if reminderTime >= 0 {
            
            let content = UNMutableNotificationContent()
            content.title = "Workout reminder"
            content.subtitle = "Workour with \(client.clientName) tomorrow."
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderTime, repeats: false)
            
            let request = UNNotificationRequest(identifier: client.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
        
     }
}
