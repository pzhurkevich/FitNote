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
    @Published var days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
// MARK:  - Methods -
    
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else { return Date() }
        return currentMonth
    }
    
    func fillDates() -> [DateInCalendar] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        let monthToReturn = currentMonth.getAllDates().compactMap { date -> DateInCalendar in
            let day = calendar.component(.day, from: date)
            return DateInCalendar(day: day, date: date)
        }
        return monthToReturn
    }
    
    func displayData() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
//        guard let currentDate = currentDate else {
//            print("empty data")
//            return []
//        }
        let date = formatter.string(from: currentDate)
        print(date)
        return date.components(separatedBy: " ")
    }
        
}
