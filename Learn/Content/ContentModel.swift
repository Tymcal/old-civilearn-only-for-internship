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
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case asset
        case nodes
    }
}

struct Node: Codable, Identifiable {
    var id: String? = UUID().uuidString
    var name: String
    var timestamp: Double
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
    var jumpTo: Double = 0.00
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case jumpTo
    }
}
