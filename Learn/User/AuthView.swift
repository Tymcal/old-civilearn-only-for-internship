//
//  SignInView.swift
//  Learn
//
//  Created by Teema Khawjit on 7/6/23.
//

import SwiftUI

struct AuthView: View {
    
    @State private var showError = false
    @State private var showSignUp = true
    
    @State private var firtsname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    @State private var pswd: String = ""
    @State private var user: User? = nil
    
    @Binding var isLoggedIn: Bool
    @Binding var token: String

    var body: some View {
        
        VStack {
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(50)
            
            if showSignUp {
                HStack {
                    TextField("First Name", text: $firtsname)
                        .textFieldStyle(.roundedBorder)
                    TextField("Last Name", text: $lastname)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            TextField("Email Address", text: $email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $pswd)
                .textFieldStyle(.roundedBorder)

            
            Button(showSignUp ? "Sign Up" : "Sign In") {
                if showSignUp {
                    user = User(firstname: firtsname, lastname: lastname, email: email, pswd: pswd)
                    Task {
                        do {
                            try await signupHandler()
                        } catch {
                            print (error.localizedDescription)
                        }
                    }
                } else {
                    user = User(email: email, pswd: pswd)
                    Task {
                        do {
                            try await loginHandler()
                        } catch {
                            print (error.localizedDescription)
                        }
                    }
                    
                }
            }
            .fontWeight(.bold)
            .frame(width: 300, height: 60)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(20)
            .padding(50)
            
            Button {
                //try await getUser()
                self.showSignUp = !self.showSignUp
            } label: {
                Text(self.showSignUp ? "Already have an account?" : "Dont have an account?")
            }
        }
        .frame(width: 300)
    }
    
}

extension AuthView {
    
    private func signupHandler() async throws {
        let url = URL(string: "http://tymcal.com:8000/auth/signup")!
        var urlRequest = URLRequest (url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encodedUser = try? JSONEncoder().encode(user) else {
            return
        }
        
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodedUser)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
            print("Error \(errorData)")
            throw URLError(.cannotParseResponse)
        }
        
        let jsonData = try JSONDecoder().decode(LoggedInUser.self, from: data)
        isLoggedIn = true
        token = jsonData.token
        print(jsonData.userId)
        print("token: \(token)")
    }
    
    private func loginHandler() async throws {
        let url = URL(string: "http://tymcal.com:8000/auth/login")!
        var urlRequest = URLRequest (url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encodedUser = try? JSONEncoder().encode(user) else {
            return
        }
        
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodedUser)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
            print("Error \(errorData)")
            throw URLError(.cannotParseResponse)
        }
        
        let jsonData = try JSONDecoder().decode(LoggedInUser.self, from: data)
        isLoggedIn = true
        token = jsonData.token
        print(jsonData.userId)
    }
    
}

#Preview {
    ContentView()
}
