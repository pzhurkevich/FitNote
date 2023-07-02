//
//  Date+Extension.swift
//  FitNote
//
//  Created by Pavel on 27.06.23.
//

import Foundation

extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self)),
              let period = calendar.range(of: .day, in: .month, for: startDate) else {return []}
                
        return period.compactMap { day -> Date in
            guard let datesForCalendar = calendar.date(byAdding: .day, value: day - 1, to: startDate) else { return Date()}
            return datesForCalendar
        }
    }
    
    
    func checkDay(date: Date) -> Bool {
            let calendar = Calendar.current
            return calendar.isDate(self, inSameDayAs: date)
        }

    func displayData() -> [String] {
         let formatter = DateFormatter()
         formatter.dateFormat = "MMMM YYYY"
         let date = formatter.string(from: self)
         return date.components(separatedBy: " ")
     }
    
    func getDateComponents() -> DateComponents {
           let calendar = Calendar.current
           return calendar.dateComponents([.month, .year, .day], from: self)
       }


    
}
