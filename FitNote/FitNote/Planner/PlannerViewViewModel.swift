//
//  PlannerViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import Foundation
import UIKit
import UserNotifications
import Combine

final class PlannerViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    
    let fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    let calendar = Calendar.current
    let notificationCenter = UNUserNotificationCenter.current()
    private var cancellable =  Set<AnyCancellable>()
    
    @Published var currentDate: Date = Date()
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Int = 0 {
        didSet {
            currentDate = getCurrentMonth()
            fillDates()
        }
    }
    @Published var days: [String] = []

    @Published var clients: [Client] = []
    @Published var names: [String] = []
    @Published var selectedClient = Client()
    @Published var newClientName = ""
    
    @Published var tasks: [ClientTaskData] = []
    @Published var daysInCalendar: [DateInCalendar] = []
    
    @Published var isShown = false
    @Published var showAlert = false
    @Published var emptyName = false
    @Published var nameErrorText: nameError = .emptyName
    
    enum nameError: String {
        
        case emptyName = "Name cannot be empty"
        case nameExist = "Client with same name is already exists"
    }
    
// MARK:  - Methods -
    init() {
      
        fillDates()
        fillWeekDays()
        
        $newClientName
            .sink { [weak self] _ in
                guard let self = self else { return }
                emptyName = false
                if newClientName.isEmpty {
                    emptyName = true
                    nameErrorText = .emptyName
                }
                if names.contains(where: {$0.caseInsensitiveCompare(self.newClientName) == .orderedSame})  {
                    emptyName = true
                    nameErrorText = .nameExist
                }
               
            }
            .store(in: &cancellable)
    }
    
   
      
        
        

    deinit {
            cancellable.removeAll()
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
    
    
    func addNewClientToPlanner() {
        let id = UUID().uuidString
        let idData = UUID().uuidString
        let idClient = UUID().uuidString
        guard !newClientName.isEmpty, !names.contains(where: {$0.caseInsensitiveCompare(self.newClientName) == .orderedSame}) else {
            return
        }

        let newClient = Client(id: idClient, name: newClientName, instURL: "-", number: "-", imageURL: "")
        let client = ClientTask(id: id, client: newClient, time: selectedDate)
        let taskData = ClientTaskData(id: idData, task: [client], taskDate: selectedDate)
        
        if tasks.isEmpty {
            tasks.append(taskData)
        } else {
            tasks = tasks.map { clientTaskData -> ClientTaskData in
                if clientTaskData.task.contains(where: { $0.time.getDateComponents() == selectedDate.getDateComponents() }) {
                    var updated = clientTaskData
                    updated.addTask(newClient: client)
                    return updated
                } else {
                    return clientTaskData
                }
            }
            
            if !tasks.contains(where: { $0.taskDate.getDateComponents() == selectedDate.getDateComponents() }) {
                tasks.append(taskData)
            }
        }

        Task {
            await fireBaseManager.saveClientsPlanner(allTasks: tasks)
            await fireBaseManager.addClientFromPlanner(client: newClient)
        }
        
        createNotification(client: client)
        
        isShown.toggle()
    }
    
    func addExistingClientToPlanner() {
        let id = UUID().uuidString
        let idData = UUID().uuidString

        let client = ClientTask(id: id, client: selectedClient, time: selectedDate)
        let taskData = ClientTaskData(id: idData, task: [client], taskDate: selectedDate)
        
        if tasks.isEmpty {
            tasks.append(taskData)
        } else {
            tasks = tasks.map { clientTaskData -> ClientTaskData in
                if clientTaskData.task.contains(where: { $0.time.getDateComponents() == selectedDate.getDateComponents() }) {
                    var updated = clientTaskData
                    updated.addTask(newClient: client)
                    return updated
                } else {
                    return clientTaskData
                }
            }
            
            if !tasks.contains(where: { $0.taskDate.getDateComponents() == selectedDate.getDateComponents() }) {
                tasks.append(taskData)
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
    
    func deleteClient(allTask: ClientTaskData, client: ClientTask) {
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [client.id])
        
        let updatedTasks = allTask.task.filter { $0.id != client.id }
        
        if updatedTasks.isEmpty {
            fireBaseManager.deleteOneClientTask(docId: allTask.id)
            tasks = tasks.filter { $0.id != allTask.id }
        } else {
            let updatedClientTaskData = ClientTaskData(id: allTask.id, task: updatedTasks, taskDate: allTask.taskDate)
            tasks = tasks.filter { $0.id != allTask.id }
            tasks.append(updatedClientTaskData)
            tasks = tasks.filter { !$0.task.isEmpty }
        }
        Task { [weak self] in
            guard let self = self else {return}
            await fireBaseManager.saveClientsPlanner(allTasks: tasks)
            await fetchTasksToPlanner()
        }
    }
    

    func fetchClients() async {

           
        let clientsFromServer  =  await self.fireBaseManager.fetchClients()
            await MainActor.run {
                self.names = clientsFromServer.map { $0.name }
                self.clients = clientsFromServer
                if let firstClient = clients.first {
                    selectedClient = firstClient
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
            let time = client.time.stringTime()
            content.title = "Workout reminder"
            content.subtitle = "Workour with \(client.client.name) tomorrow at \(time)."
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderTime, repeats: false)
            
            let request = UNNotificationRequest(identifier: client.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
        
     }
}
