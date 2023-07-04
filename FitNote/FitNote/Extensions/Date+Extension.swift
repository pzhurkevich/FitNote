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
//        return formatter.string(from: date)
//        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    }
