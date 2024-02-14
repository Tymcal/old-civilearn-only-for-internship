//
//  PlayerView.swift
//  Learn
//
//  Created by Teema Khawjit on 9/6/23.
//

import SwiftUI
import AVKit

struct PlayerView_original: View {
    @State private var currentTime: Int = 0
    @State private var previousTime: Int = 0
    @State private var isPlaying = false
    @State private var duration: Int = 0
    
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "usecase", ofType: "mp4")!))
//        let player = AVPlayer(url: URL(string: "https://tymcal.com/civilearn/src/assets/usecase.mp4")!)
        
        let asset = AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "usecase", ofType: "mp4")!))
        
        VStack {
            ZStack {
                VideoPlayer(player: player)
                    .onAppear {
                        Task {
                            duration = Int(CMTimeGetSeconds(try await  asset.load(.duration)) * 100)
                            print(duration)
                        }
                        player.addPeriodicTimeObserver(forInterval: CMTime(value: 5, timescale: 1000), queue: .main) { time in
                            self.currentTime = Int(time.value) / 10000000
                            
                            for timestamp in timestamps {
                                //to able to pass node value to DecisionView
                                decisionPopup(timestamp, player)
                            }
                        }
                    }
                    .allowsHitTesting(true)
            }
            HStack {
                Button {
                    player.pause()
                    print(player.currentTime())
                } label: {
//                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    Image(systemName: "pause.fill")
                }
                
                Button {
                    player.play()
                } label: {
                    Image(systemName: "play.fill")
                }
                Button {
                    player.seek(to: CMTime(value: 5718, timescale: 1000))
                    print(player.currentTime())

                } label: {
                    Text("Seek")
                }
            }
            .frame(height: 50)
        }
        
    }
    
    var timestamps = [1611, 2640, 3200]
    func decisionPopup(_ timestamp: Int, _ player: AVPlayer) {
        //avoid double popup checker
        if currentTime != previousTime
            &&
            currentTime == timestamp {
//            showingSheet = true
            print("Pop over!")
            player.pause()
        print(player.currentTime().value)
//            //send currentTime to prev
            previousTime = currentTime
        }
    }
}

struct PlayerView_orginal_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView_original()
            .previewInterfaceOrientation(.landscapeLeft)

    }
}
