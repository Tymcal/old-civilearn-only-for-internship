//
//  LearnApp.swift
//  Learn
//
//  Created by Teema Khawjit on 3/19/23.
//

import SwiftUI

@main
struct LearnApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
