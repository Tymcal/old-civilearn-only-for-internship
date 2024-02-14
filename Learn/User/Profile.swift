//
//  Profile.swift
//  Learn
//
//  Created by Teema Khawjit on 12/22/23.
//

import SwiftUI

struct ProfileButton: View {
    
    @Binding var showSignUp: Bool
    @Binding var isLoggedIn: Bool
    @Binding var token: String
    
    var body: some View {
        NavigationLink {
            ProfileView(showSignUp: $showSignUp, isLoggedIn: $isLoggedIn, token: $token)
                .toolbar {
                    Button("logout") {
                        token = ""
                        isLoggedIn = false
                        showSignUp = false
                    }
                }
        } label: {
            Image(systemName: "person.crop.circle").foregroundColor(.blue)
        }
    }
}

struct ProfileView: View {
    
    @Binding var showSignUp: Bool
    @Binding var isLoggedIn: Bool
    @Binding var token: String
    
    var body: some View {
        Text("Profile")
    }
}
