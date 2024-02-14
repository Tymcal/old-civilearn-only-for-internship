//
//  ContentModel.swift
//  Learn
//
//  Created by Teema Khawjit on 12/22/23.
//

import Foundation

struct Content: Codable, Identifiable {
    var id: String? = UUID().uuidString
    var title: String
    var asset: String
    var nodes: [Node] = []
    var creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case asset
        case nodes
        case creator
    }
}

struct Node: Codable, Identifiable {
    var id: String? = UUID().uuidString
    var name: String
    var timestamp: Int
    var branchs: [Branch]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case timestamp
        case branchs
    }
}

struct Branch: Codable, Identifiable {
    var id: String? = UUID().uuidString
    var name: String = "Unnamed"
    var jumpTo: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case jumpTo
    }
}

struct Creator: Hashable, Codable, Identifiable {
    var id: String? = UUID().uuidString
    var firstname: String
    var lastname: String
    var email: String = ""
    var line: String = ""
    var messenger: String = ""
    var tel: String = ""
}
