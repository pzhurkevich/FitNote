//
//  ClientTask.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import Foundation

struct ClientTask: Identifiable, Codable, Comparable {
    static func == (lhs: ClientTask, rhs: ClientTask) -> Bool {
        return lhs.id == rhs.id && lhs.time == rhs.time

    }
    
    static func < (lhs: ClientTask, rhs: ClientTask) -> Bool {
        return lhs.time < rhs.time
    }
    
    let id: String
    var client: Client
    var time: Date    
}

struct ClientTaskData: Identifiable, Codable {
    let id: String
    var task: [ClientTask]
    var taskDate: Date
    
    mutating func addTask(newClient: ClientTask){
        task.append(newClient)
        task = task.sorted()
      }
    
}
