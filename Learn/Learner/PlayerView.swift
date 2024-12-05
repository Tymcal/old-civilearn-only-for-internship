//
//  PlayerView.swift
//  Learn
//
//  Created by Teema Khawjit on 12/26/23.
//
import SwiftUI
import AVKit

var isFromPlayerView: Bool = false

struct PlayerView: View {
    
    @Binding var event: Event
    var content: Content
    @Binding var isFromPlayerView: Bool
    
//    init(event: Binding<Event>, content: Content) {
//        self._event = event
//        self.content = content
//    }
    
    @State private var currentTime: Int = 0
    @State private var previousTime: Int = 0
    @State private var decisionTemp: Decision = Decision(answer: "", startTime: "", endTime: "")
    @State private var showingNode: Bool = false
    @State private var branchsStored : [Branch] = [Branch(name: "A1", jumpTo: 5)]
    @State private var duration: Int = 0
    
    @State private var width: CGFloat = UIScreen.main.bounds.width
    
    @Environment(\.dismiss) private var dismiss
    //@Environment(\.isSceneCaptured) private var isSceneCaptured
    
    @Binding var isLoggedIn: Bool
    @Binding var token: String
    
    var body: some View {
//        let player = AVPlayer(url: URL(string: content.asset)!)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "usecase", ofType: "mp4")!)
        
        let player = AVPlayer(url: url)
        let asset = AVAsset(url: url)
        
        VStack {
            
            // -----------------------------
            // To Lobby
            // -----------------------------
            HStack {
                Button(content.title) {
                    Task {
                        player.pause()
                        event.isPlaying = false
                        event.contPlaying = Int(player.currentTime().value) / 10000000
                        print(event.contPlaying)
                        isFromPlayerView = true
                        dismiss()
                    }
                    
                }
                    .buttonStyle(LobbyButton())
                Spacer()
            }
            
            // -----------------------------
            // Player
            // -----------------------------
            VideoPlayer(player: player)
                .onAppear {
                    Task {
                        duration = Int(CMTimeGetSeconds(try await  asset.load(.duration)) * 100)
                        print(duration)
                        event.isPlaying = true
                        print(event.contPlaying)
                        print(CMTime(value: CMTimeValue(event.contPlaying * 10000000), timescale: 1000000000))
                        await player.seek(to: CMTime(value: CMTimeValue(event.contPlaying * 10000000), timescale: 1000000000))
                        player.play()
                        //video time observer
                        player.addPeriodicTimeObserver(forInterval: CMTime(value: 5, timescale: 1000), queue: .main) { time in
                            
                            self.currentTime = Int(time.value) / 10000000
                            
                            // Once video ends
                            if currentTime == duration {
                                event.isPlaying = false
                                event.contPlaying = 0
                                isFromPlayerView = true
                                dismiss()
                            }
                            
                            for node in content.nodes {
                                //to able to pass node value to DecisionView
                                nodePopup(node.timestamp, player, node.branchs)
                            }
                            
                        }
                    }
                }
            //leave this player at the end of video
                .onDisappear {
                    Task {
                        try await patchEvent(event: event) //update Event
                    }
                }
                .allowsHitTesting(false)
                .frame(width: width, height: width*9/16)
            
            // -----------------------------
            // DecisionView (Disabled)
            // -----------------------------
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
//                    if showingNode {
//                        DecisionView(event: $event, player: player, branchs: $branchsStored, startTime: $startTime, showingNode: $showingNode)
//                            .frame(width: width*0.965, height: 60)
//                            .background(.thickMaterial)
//                            .cornerRadius(10)
//                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
//                    }
            }
            
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(.black)
        .fullScreenCover(isPresented: $showingNode) {
            VStack {
                Spacer()
                DecisionView(event: $event, player: player, branchs: $branchsStored, decisionTemp: $decisionTemp, showingNode: $showingNode)
                    .frame(width: width*0.965, height: 60)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
            }
            .presentationBackground(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom).opacity(0.50))
        }
        .statusBar(hidden: false)
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [])
                    }
                    catch {
                        print("Setting category to AVAudioSessionCategoryPlayback failed.")
                    } //volume = 1.0 in silent mode
        }
    }
}

struct LobbyButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 150, height: 40)
            .background(.thickMaterial)
            .cornerRadius(100)
            .padding(10)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

extension PlayerView {
    func nodePopup(_ timestamp: Int, _ player: AVPlayer, _ branchs: [Branch]) {
        //avoid double popup checker
        if currentTime != previousTime && currentTime == timestamp {
            player.pause()
            branchsStored = branchs
            withAnimation { showingNode = true }
            decisionTemp.startTime = dateTimeStamp()
            previousTime = currentTime //so that it wont repeat popup itself
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
    
    func leavePlayer(player: AVPlayer) async throws {
        player.pause()
        event.isPlaying = false
        event.contPlaying = Int(player.currentTime().value) / 10000000
        isFromPlayerView = true
//                    print("After ----------")
//                    print(event)
//                    print("----------------")
        
        //update Event
        try await patchEvent(event: event)
        
        dismiss()
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

#Preview {
        ContentView()
}
