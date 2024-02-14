//
//  TimerView.swift
//  Learn
//
//  Created by Teema Khawjit on 8/21/23.
//

import SwiftUI
import AVKit

var isFromPlayerView = false

struct TimerView: View {
    
    var getEvent: Event
    @State private var event: Event =
                Event(
                    id: "0",
                    title: "Untitled",
                    decisions: [],
                    isPlaying: false,
                    contPlaying: 0)
            
    var content: Content
    
    @State private var isFromPlayerView: Bool = false
    
    @Binding var isLoggedIn: Bool
    @Binding var token: String

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Text(content.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(25)
                
                HStack {
                    
                    NavigationLink {
                        AnotherView(event: $event, content: content, isFromPlayerView: $isFromPlayerView, isLoggedIn: $isLoggedIn, token: $token)
                            .background(.black)
                    } label: {
                        Text(isFromPlayerView ? "Resume" : "Play")
                            .onTapGesture {
                                if event.isPlaying {
                                    print("Content is already played in the other device")
                                }
                            }
                    }
                    .buttonStyle(ShortBigButton(background: .blue))
                    .onAppear {
                        if isFromPlayerView == false {
                            event = getEvent
                        }   
                    }
                    
//                    Menu("Help!") {
//                        Text("\(content.creator.firstname) \(content.creator.lastname)")
//                        Link(destination: URL(string: "mailto:\(content.creator.email)")!) {
//                            Label("Mail", systemImage: "envelope.fill")
//                                .font(.largeTitle)
//                        }
//                        Link(destination: URL(string: content.creator.line)!) {
//                            Label("Line", systemImage: "message.fill")
//                                .foregroundColor(.green)
//                                .font(.largeTitle)
//                        }
//                        Link(destination: URL(string: content.creator.messenger)!) {
//                            Label("Messenger", systemImage: "message.fill")
//                                .foregroundColor(.purple)
//                                .font(.largeTitle)
//                        }
//                        Link(destination: URL(string: "tel:\(content.creator.tel)")!) {
//                            Label("Phone", systemImage: "phone.fill")
//                                .font(.largeTitle)
//                        }
//                    }
//                    .buttonStyle(ShortBigButton(background: .gray.opacity(0.15), foreground: .accentColor))
                
                }
                Spacer()
                }
        }
    }
}

struct AnotherView: View {
    
    @Binding var event: Event
    var content: Content
    @Binding var isFromPlayerView: Bool
    
    @State private var width: CGFloat = UIScreen.main.bounds.width

    @State private var showDadada: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentTime: Int = 0
    @State private var previousTime: Int = 0
    @State private var decisionTemp: Decision = Decision(answer: "", startTime: "", endTime: "")
    @State private var showingNode: Bool = false
    @State private var branchsStored : [Branch] = [Branch(name: "A1", jumpTo: 5)]
    
    @Binding var isLoggedIn: Bool
    @Binding var token: String
    
    var body: some View {
        
        //print(content)
        
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "test", ofType: "mp4")!))
        
        VStack {
            
            HStack {
                Button(content.title) {
                    Task {
                        player.pause()
                        event.isPlaying = false
                        event.contPlaying = Int(player.currentTime().value)
                        isFromPlayerView = true
    //                    print("After ----------")
    //                    print(event)
    //                    print("----------------")
                        try await patchEvent(event: event)
                        //update Event
                        dismiss()
                    }
                }
                    .buttonStyle(LobbyButton())
                Spacer()
            }
                          
            VideoPlayer(player: player)
                .onAppear {
                    Task {
                        event.isPlaying = true
                        //update
                        try await patchEvent(event: event)
                        await player.seek(to: CMTime(value: CMTimeValue(event.contPlaying), timescale: 1000))
    //                    print("Before ---------")
    //                    print(event)
    //                    print("----------------")
                        player.play()
                        //video time observer
                        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                            self.currentTime = Int(time.value)
                            
                            for node in content.nodes {
                                
                                //to able to pass node value to DecisionView
                                nodePopup(node.timestamp, player, node.branchs)
                                
                            }
                        }
                    }
                }
                .allowsHitTesting(true)
                .frame(width: width, height: width*9/16)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
//                    if showingNode {
//                        DecisionView(event: $event, player: player, branchs: $branchsStored, decisionTemp: $decisionTemp, showingNode: $showingNode)
//                            .frame(width: width*0.965, height: 60)
//                            .background(.thickMaterial)
//                            .cornerRadius(10)
//                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
//                            .onAppear {
//                                
//                            }
//                    }
            }
//            ZStack {
//                Rectangle()
//                    .foregroundColor(.clear)
//                if showDadada {
//                    Button("event.title") {
//                        
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
//                }
//                
//            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $showingNode) {
            VStack {
                Spacer()
                DecisionView(event: $event, player: player, branchs: $branchsStored, decisionTemp: $decisionTemp, showingNode: $showingNode)
                    .frame(width: width*0.965, height: 60)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
            }
                .presentationBackground(.clear)
        }
        .statusBar(hidden: false)
        
    }
}

extension AnotherView {
    func nodePopup(_ timestamp: Int, _ player: AVPlayer, _ branchs: [Branch]) {
        //avoid double popup checker
        if currentTime != previousTime
            &&
            currentTime == timestamp {
            player.pause()
            branchsStored = branchs
            withAnimation { showingNode = true }
            decisionTemp.startTime = dateTimeStamp()
            previousTime = currentTime
            //so that it wont repeat popup itself
        }
    }
    
    func dateTimeStamp() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .short
        print(formatter.string(from: currentDateTime))
        return formatter.string(from: currentDateTime)
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
                //events = jsonData.events
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

extension TimerView {
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
                //events = jsonData.events
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
