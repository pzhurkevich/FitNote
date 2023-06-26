//
//  PlannerViewViewModel.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import Foundation

final class PlannerViewViewModel: ObservableObject {
    
// MARK:  - Variables -
    @Published var currentDate: Date = Date()
    @Published var currentMonth: Int = 0
    @Published var days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
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
        print(firstWeekday)
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
        
}
