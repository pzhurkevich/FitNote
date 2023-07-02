//
//  Client.swift
//  FitNote
//
//  Created by Pavel on 19.06.23.
//

import Foundation

struct Client: Identifiable, Codable {
    let id: String
    let name: String
    let instURL: String
    let number: String
    let imageURL: String
   
    init(id: String = "id", name: String = "Client", instURL: String = "URL", number: String = "numb", imageURL: String = "imgURL") {
        self.id = id
        self.name = name
        self.instURL = instURL
        self.number = number
        self.imageURL = imageURL
    }

}
