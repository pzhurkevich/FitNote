//
//  Date+Extension.swift
//  FitNote
//
//  Created by Pavel on 4.07.23.
//

import Foundation

extension Date {
    
    func stringEnDate()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM dd, yyyy")
        return dateFormatter.string(from: self)
    }
    
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

      func stringYear() -> String {
           let formatter = DateFormatter()
          formatter.locale = Locale(identifier: "en")
           formatter.dateFormat = "YYYY"
           let date = formatter.string(from: self)
           return date
       }
      
      func getDateComponents() -> DateComponents {
             let calendar = Calendar.current
             return calendar.dateComponents([.month, .year, .day], from: self)
         }

    func stringEnMonth()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        return dateFormatter.string(from: self)
    }
   
    
    }
