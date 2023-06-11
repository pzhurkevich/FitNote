//
//  AlamofireProvider.swift
//  FitNote
//
//  Created by Pavel on 11.06.23.
//

import Foundation
import Alamofire

protocol ProviderProtocol {
    func getAllExercise() async throws -> [Exercise]
}

class AlamofireProvider: ProviderProtocol {
  
    func getAllExercise() async throws -> [Exercise] {
        return try await
        AF.request(Constants.dbURL, method: .get).serializingDecodable([Exercise].self).value
    }
    
    
}
