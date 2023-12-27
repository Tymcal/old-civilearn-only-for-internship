//
//  UserModel.swift
//  Learn
//
//  Created by Teema Khawjit on 7/6/23.
//

import Foundation

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
        case contact
    }
}

struct Event: Codable, Identifiable {
    var id: String?
    var title: String
    var asset: String
    var decisions: [Decision]
    var creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case asset
        case decisions
        case creator
    }
}

struct Decision: Codable, Identifiable {
    var id: String?
    var answer: String
    var duration: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case answer
        case duration
    }
}

struct Contact: Hashable, Codable {
    var line: String = ""
    var messenger: String = ""
    var tel: String = ""
}

struct Creator: Hashable, Codable, Identifiable {
    var id: String?
    var firstname: String
    var lastname: String
    var email: String = ""
    var line: String = ""
    var messenger: String = ""
    var tel: String = ""
}

struct LoggedInUser: Codable {
    var token: String
    var userId: String
     
    enum CodingKeys: CodingKey {
        case token
        case userId
    }
}
