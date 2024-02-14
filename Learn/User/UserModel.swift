//
//  UserModel.swift
//  Learn
//
//  Created by Teema Khawjit on 7/6/23.
//

import Foundation
import Combine

//Learner

struct User: Codable {
    var firstname: String?
    var lastname: String?
    var email: String
    var pswd: String
    var contact: Contact?
    
    enum CodingKeys: String, CodingKey {
        case firstname
        case lastname
        case email
        case pswd
    }
}

struct Contact: Hashable, Codable {
    var line: String = ""
    var messenger: String = ""
    var tel: String = ""
}

struct Event: Codable, Identifiable {
    var id: String? = UUID().uuidString
    var title: String
    var decisions: [Decision]
    var isPlaying: Bool
    var contPlaying: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case decisions
        case isPlaying
        case contPlaying
    }
}

struct Decision: Codable, Identifiable {
    var id: String? = UUID().uuidString
    var answer: String
    var startTime: String
    var endTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case answer
        case startTime
        case endTime
    }
}

struct LoggedInUser: Codable {
    var token: String
    var userId: String
     
    enum CodingKeys: CodingKey {
        case token
        case userId
    }
}
