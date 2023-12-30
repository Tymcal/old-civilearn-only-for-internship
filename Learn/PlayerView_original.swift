//
//  PlayerView.swift
//  Learn
//
//  Created by Teema Khawjit on 9/6/23.
//

import SwiftUI
import AVKit

struct PlayerView_original: View {
    private var fileName: String = "IMG_4966"
    @State private var currentTime: Double = 0.0
    @State private var previousTime: Double = 0.0
    @State var showingSheet = false
    
    @ObservedObject private var modelData = ModelData()
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "MOV")!))
        ZStack {
            VideoPlayer(player: player)
                .onAppear {
                    player.play()
                    //video time observer
                    player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                        self.currentTime = round(CMTimeGetSeconds(time) * 100)/100.0
                        
                        for timestamp in timestamps {
                            decisionPopup(timestamp, player)
                        }
                        
                    }
                }
                .allowsHitTesting(true)
        }
            .sheet(isPresented: $showingSheet) {
                DecisionDetail(content: modelData.drafts[0], decision: modelData.drafts[0].nodes[0])
            }
    }
    
    var timestamps = [3.00, 5.00]
    func decisionPopup(_ timestamp: Double, _ player: AVPlayer) {
        //avoid double popup checker
        if currentTime != previousTime
            &&
            currentTime == timestamp {
            showingSheet = true
            print("Pop over!")
            player.pause()
            //send currentTime to prev
            previousTime = currentTime
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView_original()
            .previewInterfaceOrientation(.landscapeLeft)

    }
}
