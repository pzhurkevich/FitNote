//
//  DateCalendar.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import Foundation


struct DateInCalendar: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
