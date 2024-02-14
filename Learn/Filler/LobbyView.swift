import SwiftUI
import Foundation
import AVKit

struct LobbyView: View {
    
    var getEvent: Event
    @State private var event: Event = Event(title: "Unititled", decisions: [], isPlaying: false, contPlaying: 0)
    var content: Content
    @State private var isFromPlayerView: Bool = false
    @State private var showAlert = false
    
    @Binding var isLoggedIn: Bool
    @Binding var token: String
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                // -----------------------------
                // Content name
                // -----------------------------
                Text(content.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(25)
                    
                HStack {
                    
                    // -----------------------------
                    // Play
                    // -----------------------------
                    NavigationLink {
                        PlayerView(event: $event, content: content, isFromPlayerView: $isFromPlayerView, isLoggedIn: $isLoggedIn, token: $token)
                    } label: {
                        Text(isFromPlayerView ? "Resume" : "Play")
                            .onTapGesture {
                                if event.isPlaying {
                                    showAlert = true
                                }
                            }
                            .alert("Unable to play", isPresented: $showAlert) {
                                Button {
                                    
                                } label: {
                                    Text("OK")
                                }
                            } message: {
                                Text("Content is already played in the other device")
                            }
                    }
                    .buttonStyle(ShortBigButton(background: .blue))
                    .onAppear {
                        if isFromPlayerView == false {
                            event = getEvent
                        }
                    }
                    
                    // -----------------------------
                    // Help
                    // -----------------------------
                    Menu("Help!") {
                        
                        Text("\(content.creator.firstname) \(content.creator.lastname)")
                        Link(destination: URL(string: "mailto:\(content.creator.email)")!) {
                            Label("Mail", systemImage: "envelope.fill")
                                .font(.largeTitle)
                        }
                        
                        if content.creator.line != "" {
                            Link(destination: URL(string: content.creator.line)!) {
                                    Label("Line", systemImage: "message.fill")
                                        .foregroundColor(.green)
                                        .font(.largeTitle)
                                }
                        }
                        
                        if content.creator.messenger != "" {
                            Link(destination: URL(string: content.creator.messenger)!) {
                                Label("Messenger", systemImage: "message.fill")
                                    .foregroundColor(.purple)
                                    .font(.largeTitle)
                                }
                        }
                        
                        if content.creator.tel != "" {
                            Link(destination: URL(string: "tel:\(content.creator.tel)")!) {
                                Label("Phone", systemImage: "phone.fill")
                                    .font(.largeTitle)
                            }
                                }
                        
                    }
                    .buttonStyle(ShortBigButton(background: .gray.opacity(0.15), foreground: .accentColor))
                    
                }
                Spacer()
            }
        }
        
    }
}

struct ShortBigButton: ButtonStyle {
    @State var background: Color
    @State var foreground: Color?
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(width: 200, height: 60)
            .foregroundColor(foreground ?? .white)
            .background(background)
            .cornerRadius(20)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}
