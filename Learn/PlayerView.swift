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
    
    private var width: CGFloat = UIScreen.main.bounds.width
    
    private var fileName: String = "test"
    
    @State private var currentTime: Double = 0.0
    @State private var previousTime: Double = 0.0
    @State var showingSheet = false
    
    var body: some View {
//        let player = AVPlayer(url: URL(string: contentX.asset)!)
        
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "mp4")!))
        
        ZStack {
            Rectangle()
                .foregroundColor(.primary)
                .ignoresSafeArea()
            VideoPlayer(player: player)
                .onAppear {
                    //video time observer
                    player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                        self.currentTime = round(CMTimeGetSeconds(time) * 100)/100.0
                        for node in content.nodes {
                            withAnimation {
                                decisionPopup(node.timestamp, player)
                            }
                        }
                    }
                }
                .allowsHitTesting(true)
                .frame(width: width, height: width*9/16)
            if showingSheet {
                VStack {
                    Spacer()
                    DecisionView(branchs: content.nodes[0].branchs)
                        .frame(width: width*0.965, height: 60)
                        .background(.thickMaterial)
                        .cornerRadius(10)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    func decisionPopup(_ timestamp: Double, _ player: AVPlayer) {
        //avoid double popup checker
        if currentTime != previousTime
            &&
            currentTime == timestamp {
            showingSheet = true
            print("\(timestamp) Pop over!")
            player.pause()
            //send currentTime to prev
            previousTime = currentTime
        }
    }
}

#Preview {
    PlayerView(content:
        Content(title: "Mechanhics",
                asset: "https://tymcal.com/civilearn/src/assets/test.mp4",
                nodes: [
                    Node(name: "Q1",
                         timestamp: 5.00,
                         branchs: [
                            Branch(name: "2014", jumpTo: 0.07),
                            Branch( name: "2012", jumpTo: 0.23),
                            Branch(name: "2023", jumpTo: 0.07),
                            Branch(name: "2017", jumpTo: 0.07),
                         ]),
                    Node(name: "Q2",
                         timestamp: 15.00,
                         branchs: [
                            Branch(name: "2014", jumpTo: 0.07),
                            Branch( name: "2012", jumpTo: 0.23),
                            Branch(name: "2023", jumpTo: 0.07),
                            Branch(name: "2017", jumpTo: 0.07),
                            Branch(name: "2011", jumpTo: 0.07),
                            Branch(name: "2018", jumpTo: 0.07),
                            Branch(name: "2020", jumpTo: 0.07),
                            Branch(name: "2024", jumpTo: 0.07),
                         ]),
                    Node(name: "Q3",
                         timestamp: 25.00,
                         branchs: [
                            Branch(name: "2014", jumpTo: 0.07),
                            Branch( name: "2012", jumpTo: 0.23),
                            Branch(name: "2023", jumpTo: 0.07),
                         ]),
                    Node(name: "Q4",
                         timestamp: 35.00,
                         branchs: [
                            Branch(name: "A", jumpTo: 0.07),
                            Branch( name: "B", jumpTo: 0.23),
                         ]),
                    Node(name: "Q5",
                         timestamp: 45.00,
                         branchs: [
                            Branch(id: "1", name: "2014", jumpTo: 0.07),
                            Branch(id: "2", name: "2012", jumpTo: 0.23),
                            Branch(id: "3", name: "2023", jumpTo: 0.07),
                            Branch(id: "4", name: "2017", jumpTo: 0.07),
                         ]),
                ])
    )
        .previewInterfaceOrientation(.landscapeRight)
}
