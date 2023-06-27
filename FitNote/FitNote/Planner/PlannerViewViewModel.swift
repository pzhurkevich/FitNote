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
    @Published var currentDate: Date = Date()
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Int = 0
    @Published var days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    @Published var isShown = false
    @Published var newClientName = ""
    
    @Published var tasks: [ClientTaskData] = []
    @Published var taskToDisplay: [ClientTask] = []
// MARK:  - Methods -
    
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else { return Date() }
        return currentMonth
    }
    
    func fillDates() -> [DateInCalendar] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var monthDays = currentMonth.getAllDates().compactMap { date -> DateInCalendar in
            let day = calendar.component(.day, from: date)
            return DateInCalendar(day: day, date: date)
        }
        let firstWeekday = calendar.component(.weekday, from: monthDays.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1 {
            monthDays.insert(DateInCalendar(day: 0, date: Date()), at: 0)
        }
        return monthDays
    }
    
    func displayData() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
//        guard let currentDate = currentDate else {
//            print("empty data")
//            return []
//        }
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func checkDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func addClientToPlanner() {
//        guard let dateFromPicker = selectedDate else {
//            print("no data from picker")
//            return
//        }
        let client = ClientTask(clientName: newClientName, time: selectedDate)

        if tasks.isEmpty {
           
            
            var taskToDisplay: [ClientTask] = []
            taskToDisplay.append(client)
            tasks.append(ClientTaskData(task: taskToDisplay, taskDate: selectedDate))
        } else {
            
            for i in 0..<tasks.count {
                var clientTaskData = tasks[i]
                let calendar = Calendar.current
                let componentsClient = calendar.dateComponents([.month, .year, .day], from: clientTaskData.taskDate)
                let componentsDate = calendar.dateComponents([.month, .year, .day], from: selectedDate)
                
                if componentsClient == componentsDate {
                    clientTaskData.addTask(newClient: client)
                    tasks[i] = clientTaskData
                } else {
                    //let client = ClientTask(clientName: "Anton", time: date)
                    
                    var taskToDisplay: [ClientTask] = []
                    taskToDisplay.append(client)
                    tasks.append(ClientTaskData(task: taskToDisplay, taskDate: selectedDate))
                }
            }
            
        }
        
        print(tasks)
       // self.isShown = false
    }
    
    func showDatePickerAlert() {
            let alertVC = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
            let datePicker: UIDatePicker = UIDatePicker()
            alertVC.view.addSubview(datePicker)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.selectedDate = datePicker.date
              //  self.addClientToPlanner(date: datePicker.date)
            }
            alertVC.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertVC.addAction(cancelAction)

            if let viewController = UIApplication.shared.windows.first?.rootViewController {
                viewController.present(alertVC, animated: true, completion: nil)
            }
         
        }
    
    
}
