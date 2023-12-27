//
//  ContentView.swift
//  Learn
//
//  Created by Teema Khawjit on 3/19/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isLoggedIn = false
    @State private var token: String = ""
    
    var body: some View {
        if isLoggedIn {
            HomeView(isLoggedIn: $isLoggedIn, token: $token)
        } else {
            AuthView(isLoggedIn: $isLoggedIn, token: $token)
        }
    }
}
