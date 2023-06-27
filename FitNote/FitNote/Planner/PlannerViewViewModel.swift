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
    @Published var selectedDate: Date?
    @Published var currentMonth: Int = 0
    @Published var days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
//    @Published var tasks: [ClientTaskData] = [
//        ClientTaskData(task: [
//        ClientTask(client: "Sasha"),
//        ClientTask(client: "Vika"),
//        ClientTask(client: "Artem")
//        ], taskDate: getSampleDate(offset: 1)),
//
//        ClientTaskData(task: [ClientTask(client: "Anna")], taskDate: getSampleDate(offset: -1))
//    ]
    
    @Published var tasks: [ClientTaskData] = []
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
    
    func addClientToPlanner(date: Date) {
        let client = ClientTask(client: "Anton", time: date)
        var taskToDisplay: [ClientTask] = []
        taskToDisplay.append(client)
        print(selectedDate!)
        tasks.append(ClientTaskData(task: taskToDisplay, taskDate: date))
    }
    
    func showDatePickerAlert() {
            let alertVC = UIAlertController(title: "picker", message: nil, preferredStyle: .actionSheet)
            let datePicker: UIDatePicker = UIDatePicker()
            alertVC.view.addSubview(datePicker)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.selectedDate = datePicker.date
                self.addClientToPlanner(date: datePicker.date)
            }
            alertVC.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertVC.addAction(cancelAction)

            if let viewController = UIApplication.shared.windows.first?.rootViewController {
                viewController.present(alertVC, animated: true, completion: nil)
            }
         
        }
    
    
}
