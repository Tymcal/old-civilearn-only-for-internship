//
//  Model.swift
//  Learn
//
//  Created by Teema Khawjit on 7/19/23.
//

import Foundation
import SwiftData

// Creator

struct Draft: Codable, Identifiable {
    var id = UUID()
    var title: String
    var asset: String
    var nodes: [Node] = []
    
    init(title: String, asset: String, nodes: [Node]) {
        self.title = title
        self.asset = asset
        self.nodes = nodes
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case asset
        case nodes
    }
}
