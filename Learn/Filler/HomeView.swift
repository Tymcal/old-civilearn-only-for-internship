//
//  TestView.swift
//  Learn
//
//  Created by Teema Khawjit on 12/20/23.
//

import SwiftUI
import SwiftData

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

struct Contents: Codable {
    var message: String
    var contents: [Content]
    
    enum CodingKeys: String, CodingKey {
        case message
        case contents
    }
}

struct GetContent: Codable {
    var message: String
    var content: Content
    
    enum CodingKeys: String, CodingKey {
        case message
        case content
    }
}

struct HomeView: View {
    
    @State private var events: [Event] = []
    @State private var contents: [Content] = []
    @State private var content: Content = Content(title: "Untitled",
                                                  asset: "https",
                                                  nodes: [],
                                                  creator: Creator(firstname: "Learn", lastname: "Civilium")
                                                 )
    @State private var showError = false
    
    @Binding var showSignUp: Bool
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
                            LobbyView(getEvent: event, content: content, isLoggedIn: $isLoggedIn, token: $token)
                                .task {
                                    do {
                                        try await findContent(event.title)
                                    } catch {
                                        showError = true
                                        print(error.localizedDescription)
                                    }
                                }
                                .onAppear {
                                    isFromPlayerView = false
                                }
                                
                        } label: {
                            CoverView(event: event)
                                .contextMenu {
                                    Button("Delete", role: .destructive, action: {
                                        Task {
                                            try await deleteEvent(event.id!)
                                        }
                                    })
                                }
                                .border(Color.secondary, width: 0.25)
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(width: 1080)
            }
            .padding(.horizontal)
            .navigationTitle("Home")
            .toolbar {
                Button {
                    Task {
                        try await addContent(Content(title: "คำอุปสรรค", asset: "https://tymcal.com/civilearn/src/assets/usecase.mp4",
                                                     nodes: [
                                                        Node(name: "Q1", timestamp: 1611, branchs: [
                                                            Branch(name: "e-10", jumpTo: 1611),
                                                            Branch(name: "e-9", jumpTo: 1786),
                                                            Branch(name: "e-8", jumpTo: 1611),
                                                            Branch(name: "e-7", jumpTo: 1611),
                                                            Branch(name: "e+7", jumpTo: 1611),
                                                            Branch(name: "e+8", jumpTo: 1611),
                                                            Branch(name: "e+9", jumpTo: 1611),
                                                            Branch(name: "e+10", jumpTo: 1611),
                                                        ]),
                                                        Node(name: "Q2", timestamp: 2640, branchs: [
                                                            Branch(name: "e-5", jumpTo: 2640),
                                                            Branch(name: "e-4", jumpTo: 2640),
                                                            Branch(name: "e-3", jumpTo: 3200),
                                                            Branch(name: "e-2", jumpTo: 2640),
                                                            Branch(name: "e-1", jumpTo: 2640),
                                                            Branch(name: "e+0", jumpTo: 2640),
                                                            Branch(name: "e+1", jumpTo: 2640),
                                                            Branch(name: "e+2", jumpTo: 2640),
                                                            Branch(name: "e+3", jumpTo: 2640),
                                                            Branch(name: "e+4", jumpTo: 2640),
                                                            Branch(name: "e+5", jumpTo: 2640),
                                                        ]),
                                                        Node(name: "Q3", timestamp: 3200, branchs: [
                                                            Branch(name: "e-5", jumpTo: 3200),
                                                            Branch(name: "e-4", jumpTo: 3200),
                                                            Branch(name: "e-3", jumpTo: 3200),
                                                            Branch(name: "e-2", jumpTo: 3526),
                                                            Branch(name: "e-1", jumpTo: 3200),
                                                            Branch(name: "e+0", jumpTo: 3200),
                                                            Branch(name: "e+1", jumpTo: 3200),
                                                            Branch(name: "e+2", jumpTo: 3200),
                                                            Branch(name: "e+3", jumpTo: 3200),
                                                            Branch(name: "e+4", jumpTo: 3200),
                                                            Branch(name: "e+5", jumpTo: 3200),
                                                        ]),
                                                        Node(name: "Q4", timestamp: 3526, branchs: [
                                                            Branch(name: "e-5", jumpTo: 3526),
                                                            Branch(name: "e-4", jumpTo: 3526),
                                                            Branch(name: "e-3", jumpTo: 3526),
                                                            Branch(name: "e-2", jumpTo: 3526),
                                                            Branch(name: "e-1", jumpTo: 3526),
                                                            Branch(name: "e+0", jumpTo: 3526),
                                                            Branch(name: "e+1", jumpTo: 3845),
                                                            Branch(name: "e+2", jumpTo: 3526),
                                                            Branch(name: "e+3", jumpTo: 3526),
                                                            Branch(name: "e+4", jumpTo: 3526),
                                                            Branch(name: "e+5", jumpTo: 3526),
                                                        ]),
                                                        Node(name: "Q5", timestamp: 3845, branchs: [
                                                            Branch(name: "e-5", jumpTo: 3845),
                                                            Branch(name: "e-4", jumpTo: 3845),
                                                            Branch(name: "e-3", jumpTo: 3845),
                                                            Branch(name: "e-2", jumpTo: 3845),
                                                            Branch(name: "e-1", jumpTo: 3845),
                                                            Branch(name: "e+0", jumpTo: 3845),
                                                            Branch(name: "e+1", jumpTo: 3845),
                                                            Branch(name: "e+2", jumpTo: 3845),
                                                            Branch(name: "e+3", jumpTo: 4702),
                                                            Branch(name: "e+4", jumpTo: 3845),
                                                            Branch(name: "e+5", jumpTo: 3845),
                                                        ]),
                                                        Node(name: "Q6", timestamp: 4702, branchs: [
                                                            Branch(name: "e-9", jumpTo: 4702),
                                                            Branch(name: "e-8", jumpTo: 4702),
                                                            Branch(name: "e-7", jumpTo: 4702),
                                                            Branch(name: "e-6", jumpTo: 4920),
                                                            Branch(name: "e-5", jumpTo: 4702),
                                                            Branch(name: "e+5", jumpTo: 4702),
                                                            Branch(name: "e+6", jumpTo: 4702),
                                                            Branch(name: "e+7", jumpTo: 4702),
                                                            Branch(name: "e+8", jumpTo: 4702),
                                                            Branch(name: "e+9", jumpTo: 4702),
                                                        ]),
                                                        Node(name: "Q7", timestamp: 4920, branchs: [
                                                            Branch(name: "e-9", jumpTo: 4920),
                                                            Branch(name: "e-8", jumpTo: 4920),
                                                            Branch(name: "e-7", jumpTo: 5172),
                                                            Branch(name: "e-6", jumpTo: 4920),
                                                            Branch(name: "e-5", jumpTo: 4920),
                                                            Branch(name: "e+5", jumpTo: 4920),
                                                            Branch(name: "e+6", jumpTo: 4920),
                                                            Branch(name: "e+7", jumpTo: 4920),
                                                            Branch(name: "e+8", jumpTo: 4920),
                                                            Branch(name: "e+9", jumpTo: 4920),
                                                        ]),
                                                        Node(name: "Q8", timestamp: 5172, branchs: [
                                                            Branch(name: "e-19", jumpTo: 5490),
                                                            Branch(name: "e-18", jumpTo: 5172),
                                                            Branch(name: "e-17", jumpTo: 5172),
                                                            Branch(name: "e-16", jumpTo: 5172),
                                                            Branch(name: "e-15", jumpTo: 5172),
                                                            Branch(name: "e+15", jumpTo: 5172),
                                                            Branch(name: "e+16", jumpTo: 5172),
                                                            Branch(name: "e+17", jumpTo: 5172),
                                                            Branch(name: "e+18", jumpTo: 5172),
                                                            Branch(name: "e+19", jumpTo: 5172),
                                                        ]),
                                                        Node(name: "Q9", timestamp: 5490, branchs: [
                                                            Branch(name: "e-9", jumpTo: 5740),
                                                            Branch(name: "e-8", jumpTo: 5490),
                                                            Branch(name: "e-7", jumpTo: 5490),
                                                            Branch(name: "e-6", jumpTo: 5490),
                                                            Branch(name: "e-5", jumpTo: 5490),
                                                            Branch(name: "e+5", jumpTo: 5490),
                                                            Branch(name: "e+6", jumpTo: 5490),
                                                            Branch(name: "e+7", jumpTo: 5490),
                                                            Branch(name: "e+8", jumpTo: 5490),
                                                            Branch(name: "e+9", jumpTo: 5490),
                                                        ]),
                                                        Node(name: "Q10", timestamp: 5740, branchs: [
                                                            Branch(name: "1", jumpTo: 5740),
                                                            Branch(name: "2", jumpTo: 5740),
                                                            Branch(name: "3", jumpTo: 5740),
                                                            Branch(name: "4", jumpTo: 5900),
                                                        ])
                                                     ]
                                                     ,creator: Creator(firstname: "Teema", lastname: "Khawjit", email: "teema.khawjit@gmail.com")))
                    }
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    Task {
                        try await addEvent(Event(title: "คำอุปสรรค", decisions: [], isPlaying: false, contPlaying: 0))
                    }
                } label: {
                    Image(systemName: "plus.app")
                }
                Button("addEvent") {
                    Task {
                        try await addEvent(Event(title: "Calculus", decisions: [], isPlaying: false, contPlaying: 0))
                    }
                }
                ProfileButton(showSignUp: $showSignUp, isLoggedIn: $isLoggedIn, token: $token)
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
    var event: Event
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
    
    static let blue = Color(red: 1/255, green: 96/255, blue: 250/255);
    static let purple = Color(red: 111/255, green: 72/255, blue: 163/255);
    static let red = Color(red: 239/255, green: 45/255, blue: 84/255);
    
    let gradient = Gradient(colors: [blue, purple, red])
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
    
    func getContent() async throws {
        let url = URL(string: "http://tymcal.com:8000/content/get")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let jsonData = try JSONDecoder().decode(Contents.self, from: data)
                print(jsonData.message)
                contents.append(contentsOf: jsonData.contents)
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
    
    func findContent(_ title: String) async throws {
        let url = URL(string: "http://tymcal.com:8000/content/find/\(title)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let jsonData = try JSONDecoder().decode(GetContent.self, from: data)
                print(jsonData.message)
                content = jsonData.content
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
    
    func addContent(_ content: Content) async throws {
        let url = URL(string: "http://tymcal.com:8000/content/add")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encodedContent = try? JSONEncoder().encode(content) else {
            return
        }
        
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodedContent)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let jsonData = try JSONDecoder().decode(Contents.self, from: data)
                print(jsonData.message)
                contents = jsonData.contents
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
    
    func patchContent(content: Content) async throws {
        let url = URL(string: "http://tymcal.com:8000/content/update/\(content.id!)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encodedContent = try? JSONEncoder().encode(content) else {
            return
        }
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodedContent)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let jsonData = try JSONDecoder().decode(Contents.self, from: data)
                print(jsonData.message)
                contents = jsonData.contents
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
    
    func deleteContent(_ id: String) async throws {
        let url = URL(string: "http://tymcal.com:8000/content/delete/\(id)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let jsonData = try JSONDecoder().decode(Contents.self, from: data)
                print(jsonData.message)
                contents = jsonData.contents
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
