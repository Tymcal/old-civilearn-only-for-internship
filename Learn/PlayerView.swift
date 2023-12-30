//
//  PlayerView.swift
//  Learn
//
//  Created by Teema Khawjit on 12/26/23.
//
import SwiftUI
import AVKit

struct PlayerView: View {
    
    var content: Content
    
    init (content: Content) {
        self.content = content
    }
    
    private var fileName: String = "test"
    
    @State private var currentTime: Double = 0.0
    @State private var previousTime: Double = 0.0
    @State private var showingNode: Bool = false
    @State private var branchsStored : [Branch] = [Branch(name: "A1", jumpTo: 5.00)]
    
    private var width: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
//        let player = AVPlayer(url: URL(string: contentX.asset)!)
        
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "mp4")!))
        
        ZStack {
            Rectangle()
                .foregroundColor(.primary)
                .ignoresSafeArea()
            VideoPlayer(player: player)
                .onAppear {
                    player.play()
                    //video time observer
                    player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                        self.currentTime = round(CMTimeGetSeconds(time) * 100)/100.0
                        
                        for node in content.nodes {
                            
                            //to able to pass node value to DecisionView
                            nodePopup(node.timestamp, player, node.branchs)
                            
                        }
                    }
                }
                .allowsHitTesting(true)
                .frame(width: width, height: width*9/16)
        }
        .fullScreenCover(isPresented: $showingNode, onDismiss: player.play) {
            VStack {
                Spacer()
                DecisionView(branchs: $branchsStored, showingNode: $showingNode)
                    .frame(width: width*0.965, height: 60)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
            }
                .presentationBackground(.clear)
        }
    }
    
    func nodePopup(_ timestamp: Double, _ player: AVPlayer, _ branchs: [Branch]) {
        //avoid double popup checker
        if currentTime != previousTime
            &&
            currentTime == timestamp {

            branchsStored = branchs
            withAnimation { showingNode = true }
            player.pause()
            previousTime = currentTime
            //so that it wont repeat popup itself
            
        }
    }
}

#Preview {
    PlayerView(content:
        Content(title: "Mechanhics",
                asset: "https://tymcal.com/civilearn/src/assets/test.mp4",
                nodes: [
                    Node(name: "Q1",
                         timestamp: 7.00,
                         branchs: [
                            Branch(name: "1A", jumpTo: 0.07),
                            Branch( name: "1B", jumpTo: 0.23),
                            Branch(name: "1C", jumpTo: 0.07),
                            Branch(name: "1D", jumpTo: 0.07),
                         ]),
                    Node(name: "Q2",
                         timestamp: 17.00,
                         branchs: [
                            Branch(name: "2A", jumpTo: 0.07),
                            Branch( name: "2B", jumpTo: 0.23),
                            Branch(name: "2C", jumpTo: 0.07),
                            Branch(name: "2D", jumpTo: 0.07),
                            Branch(name: "2E", jumpTo: 0.07),
                            Branch(name: "2F", jumpTo: 0.07),
                            Branch(name: "2G", jumpTo: 0.07),
                            Branch(name: "2H", jumpTo: 0.07),
                         ]),
                    Node(name: "Q3",
                         timestamp: 27.00,
                         branchs: [
                            Branch(name: "3A", jumpTo: 0.07),
                            Branch( name: "3B", jumpTo: 0.23),
                            Branch(name: "3C", jumpTo: 0.07),
                         ]),
                    Node(name: "Q4",
                         timestamp: 37.00,
                         branchs: [
                            Branch(name: "4A", jumpTo: 0.07),
                            Branch( name: "4B", jumpTo: 0.23),
                         ]),
                    Node(name: "Q5",
                         timestamp: 47.00,
                         branchs: [
                            Branch(id: "1", name: "5A", jumpTo: 0.07),
                            Branch(id: "2", name: "5B", jumpTo: 0.23),
                            Branch(id: "3", name: "5C", jumpTo: 0.07),
                            Branch(id: "4", name: "5D", jumpTo: 0.07),
                         ]),
                ])
    )
        .previewInterfaceOrientation(.landscapeRight)
}
