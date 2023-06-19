//
//  Client.swift
//  FitNote
//
//  Created by Pavel on 19.06.23.
//

import Foundation

struct Client: Identifiable, Codable {
    let id = UUID()
    let name: String
    let instURL: String
    let number: String
    let imageURL: String
   
}
