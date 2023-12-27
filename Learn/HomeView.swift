//
//  TestView.swift
//  Learn
//
//  Created by Teema Khawjit on 12/20/23.
//

import SwiftUI

struct ErrorData : Codable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

struct Events: Codable {
    var message: String
    var events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case message
        case events
    }
}

enum PrevPage {
    case none, homeView, playerView
}

struct HomeView: View {
    
    @State private var events: [Event] = []
    @State private var showError = false
    @State private var showSignUp = false
    
    @Binding var isLoggedIn: Bool
    @Binding var token: String
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(events) { event in
                        NavigationLink {
                            //EditView(content: content)
                        } label: {
                            ContentGrid(title: event.title)
                                .contextMenu {
                                    Button("Delete", role: .destructive, action: {
                                        
                                    })
                                }
                                .border(Color.secondary, width: 0.25)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Home")
            .toolbar {
                Button("add") {
                    Task {
                        try await addEvent(
                            Event(
                                title: "Mechanics",
                                asset: "4871.MOV",
                                decisions: [Decision(answer: "C", duration: 3.25),Decision(answer: "A", duration: 13.21)],
                                creator: Creator(firstname: "Prabpon", lastname: "Phraiphimuk")))
                        print("Mechanic: Done")
                        
                        try await addEvent(
                            Event(
                                title: "Wave",
                                asset: "4872.MOV",
                                decisions: [Decision(answer: "A", duration: 9.17),Decision(answer: "A", duration: 2.03)],
                                creator: Creator(firstname: "Prabpon", lastname: "Phraiphimuk")))
                        print("Wave: Done")
                        
                        try await addEvent(
                            Event(
                                title: "Electricity",
                                asset: "4873.MOV",
                                decisions: [Decision(answer: "D", duration: 0.95),Decision(answer: "C", duration: 2.79)],
                                creator: Creator(firstname: "Prabpon", lastname: "Phraiphimuk")))
                        print("Electricity: Done")
                    }
                }
                ProfileButton(isLoggedIn: $isLoggedIn, token: $token)
            }
        }
        .task {
            do {
                try await getEvent()
            } catch {
                showError = true
                print(error.localizedDescription)
            }
        }
    }
}

struct CoverView: View {
    @State var event: Event
    var body: some View {
        Button(event.title) {
            
        }
        .frame(width: 352, height: 198)
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .background(LinearGradient(gradient: gradient, startPoint: .bottomLeading, endPoint: .topTrailing)
        )
    }
    
    static let color0 = Color(red: 1/255, green: 96/255, blue: 250/255);
            
    static let color1 = Color(red: 111/255, green: 72/255, blue: 163/255);

    static let color2 = Color(red: 239/255, green: 45/255, blue: 84/255);
    
    let gradient = Gradient(colors: [color0, color1, color2])
}

extension HomeView {
    
    func getEvent() async throws {
        let url = URL(string: "http://tymcal.com:8000/event/get")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
//            print("Error \(errorData)")
//            throw URLError(.cannotParseResponse)
//        }
//        
//        let jsonData = try JSONDecoder().decode(Contents.self, from: data)
//        print(jsonData.message)
//        contents.append(contentsOf: jsonData.contents)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let jsonData = try JSONDecoder().decode(Events.self, from: data)
                print(jsonData.message)
                events.append(contentsOf: jsonData.events)
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
    
    func patchEvent(event: Event) async throws {
        let url = URL(string: "http://tymcal.com:8000/event/update/\(event.id!)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encodedEvent = try? JSONEncoder().encode(event) else {
            return
        }
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodedEvent)
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
//            
//            print("Error \(errorData)")
//            
//            throw URLError(.cannotParseResponse)
//        }
//        
//        let jsonData =  try JSONDecoder().decode(Contents.self, from: data)
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
    
    func deleteEvent(_ id: String) async throws {
        let url = URL(string: "http://tymcal.com:8000/event/delete/\(id)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
//
//            print("Error \(errorData)")
//            throw URLError(.cannotParseResponse)
//        }
//        let jsonData =  try JSONDecoder().decode(Contents.self, from: data)
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

#Preview {
        ContentView()
}
