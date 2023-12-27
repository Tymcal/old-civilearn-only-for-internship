import UIKit
//
//  Docorg.swift
//  Learn
//
//  Created by Teema Khawjit on 5/31/23.
//

import Foundation

class Node {
    var key: Int?
    var title: String?
    var children: [Node]
    
    init(title: String) {
        self.key = nil
        self.title = title
        self.children = []
    }
    
    func add(_ child: Node) {
        children.append(child)
    }
}

class Unit: Node {
}

class Title: Node {
}

class Example: Node {
//    func example(title: String) -> String {
//        Example(title: title)
//        return title
//    }
}

class Mechanism: Node {
}

class Equation: Node {
}

class Definition: Node {
}

func unit(title: String) -> Unit {
    let newUnit = Unit(title: title)
    return newUnit
}

//after the new unit is created
var unitname: String = "Calculus"
var exname: String = "Use case IRL"
//unit(title: unitname)

//once press the 'Example' button
let example = Example(title: exname)
unit(title: unitname).add(example)
