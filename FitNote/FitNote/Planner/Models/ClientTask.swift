//
//  ClientTask.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import Foundation

struct ClientTask: Identifiable {
    var id = UUID().uuidString
    var clientName: String
    var time: Date    
}

struct ClientTaskData: Identifiable {
    var id = UUID().uuidString
    var task: [ClientTask]
    var taskDate: Date
    
    mutating func addTask(newClient: ClientTask){
        task.append(newClient)
      }
    
}

//func getSampleDate(offset: Int) -> Date {
//    let calendar = Calendar.current
//    guard let date = calendar.date(byAdding: .day, value: offset, to: Date()) else { return Date()}
//    return date
//}
