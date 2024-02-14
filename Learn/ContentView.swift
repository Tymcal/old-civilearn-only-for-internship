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
    @State private var showSignUp: Bool = true
    
    var body: some View {
        if isLoggedIn {
            HomeView(showSignUp: $showSignUp, isLoggedIn: $isLoggedIn, token: $token)
        } else {
            AuthView(showSignUp: $showSignUp, isLoggedIn: $isLoggedIn, token: $token)
        }
    }
}
