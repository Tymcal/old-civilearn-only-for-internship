//
//  SignInView.swift
//  Learn
//
//  Created by Teema Khawjit on 7/6/23.
//

import SwiftUI

struct AuthView: View {
    
    @State private var events: [Event] = []
    
    @State private var showError = false
    @Binding var showSignUp: Bool
    
    @State private var firtsname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = "teema.khawjit@gmail.com"
    @State private var pswd: String = "1234567890"
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
                        .submitLabel(.next)
                    TextField("Last Name", text: $lastname)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.next)
                }
            }
            
            TextField("Email Address", text: $email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.next)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $pswd)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.continue)

            
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
            .buttonStyle(SignButton())
            
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

struct SignButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(width: 300, height: 60)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(20)
            .padding(50)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
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
        
        //only added for beta version
        Task {
            try await addEvent(Event(title: "test", decisions: [], isPlaying: false, contPlaying: 0))
        }
        
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

extension AuthView {
    func addEvent(_ event: Event) async throws {
        let url = URL(string: "http://tymcal.com:8000/event/add")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encodedEvent = try? JSONEncoder().encode(event) else {
            return
        }
        
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodedEvent)
        
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
//            print("Error \(errorData)")
//            throw URLError(.cannotParseResponse)
//        }
//
//        let jsonData = try JSONDecoder().decode(Contents.self, from: data)
//        print(jsonData.message)
//        contents = jsonData.contents
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let jsonData = try JSONDecoder().decode(Events.self, from: data)
                print(jsonData.message)
                events = jsonData.events
            } else if response.statusCode == 401 {
                token = ""
                isLoggedIn = false
                print("Unauthenticated")
            } else {
                let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
                print("Error \(errorData)")
                throw URLError(.cannotParseResponse)
            }
            
        }
    }
}
