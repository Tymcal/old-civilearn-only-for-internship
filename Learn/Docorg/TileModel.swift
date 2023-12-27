//
//  TileModel.swift
//  Learn
//
//  Created by Teema Khawjit on 6/17/23.
//

import Foundation
import SwiftUI

struct Tile: Identifiable {
    let id: UUID
    var children: [Tile]
    
    init() {
        self.id = UUID()
        self .children = []
    }
    
    mutating func add( child: Tile) {
        children.append(child)
    }
}

struct Definition: Hashable, Codable {
    var title: String
    var description: String
    
    private var imageName: String
        var image: Image {
            Image(imageName)
        }
}
