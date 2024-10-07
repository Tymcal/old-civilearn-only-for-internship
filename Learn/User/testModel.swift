//
//  testModel.swift
//  Learn
//
//  Created by Teema Khawjit on 9/5/24.
//

import Foundation

struct TestUser: Codable {
    var firstname: String
    var lastname: String
    var email: String
    var pswd: String
    var birthdate: String
    var contact: Contact
    var stats: [String]
    var exp: Int
    var past: [Event]
    var present: [Event]
    var future: [String]
    var contribution: [Content]
    
    enum CodingKeys: String, CodingKey {
        case firstname
        case lastname
        case email
        case pswd
        case birthdate
        case contact
        case stats
        case exp
        case past
        case present
        case future
        case contribution
    }
}

struct TestEvent: Hashable, Identifiable {
    var title: String
    var isPlaying: Bool
    var contPlaying: Int
    var dateAdded: String
    var learnTime: LearnTime
    var id: String { title }
}

struct LearnTime: Hashable {
    var day: CGFloat
    var start: CGFloat
    var end: CGFloat
}

struct TestDecision: Hashable, Codable {
    var userId: String
    var decision: String
    var time: Double
}

struct DecisionCount: Hashable, Codable, Identifiable {
    var decision: String
    var count: CGFloat
    var id: String { decision }
}

struct LearnTimeLog: Hashable, Codable {
    var userId: String
    var learnTime: Int
}

struct LearnTimeCount: Hashable, Codable, Identifiable {
    var time: Int
    var count: CGFloat
    var id: Int { time }
}

struct TestTimestamp: Hashable, Codable {
    var question: String
    var timestamp: Int
}


struct CorrectCount: Hashable, Codable, Identifiable {
    var question: String
    var count: Int
    var id: String { question }
}
