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
    
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "usecase", ofType: "mp4")!))
//        let player = AVPlayer(url: URL(string: "https://tymcal.com/civilearn/src/assets/usecase.mp4")!)
        VStack {
            ZStack {
                VideoPlayer(player: player)
                    .onAppear {
                        player.addPeriodicTimeObserver(forInterval: CMTime(value: 5, timescale: 1000), queue: .main) { time in
                            self.currentTime = Int(player.currentTime().value)
                            print(currentTime)
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
    
    var timestamps = [2.00, 4.00]
    func decisionPopup(_ timestamp: Double, _ player: AVPlayer) {
        //avoid double popup checker
//        if currentTime != previousTime
//            &&
//            currentTime == timestamp {
//            showingSheet = true
//            print("Pop over!")
//            player.pause()
//            //send currentTime to prev
//            previousTime = currentTime
//        }
    }
}

struct PlayerView_orginal_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView_original()
            .previewInterfaceOrientation(.landscapeLeft)

    }
}
