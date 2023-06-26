//
//  ClientTask.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import Foundation

struct ClientTask: Identifiable {
    var id = UUID().uuidString
    var client: String
    var time: Date = Date()    
}

struct ClientTaskData: Identifiable {
    var id = UUID().uuidString
    var task: [ClientTask]
    var taskDate: Date 
}

func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    guard let date = calendar.date(byAdding: .day, value: offset, to: Date()) else { return Date()}
    return date
}
