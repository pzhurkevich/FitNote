//
//  AppUser.swift
//  FitNote
//
//  Created by Pavel on 17.06.23.
//

import Foundation


struct AppUser: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let imageURL: String
    let appRole: String
}
