//
//  DecisionView.swift
//  Learn
//
//  Created by Teema Khawjit on 12/26/23.
//

import SwiftUI
import AVKit

struct DecisionView: View {
    
    @Binding var event: Event
    var player: AVPlayer
    
    @Binding var branchs: [Branch]
    @Binding var decisionTemp: Decision
    @Binding var showingNode: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Spacer()
            if branchs.count < 5 {
                HStack {
                    ForEach(branchs) { branch in
                        Button(branch.name) {
                            decisionStamp(branch.jumpTo)
                            decisionTemp.answer = branch.name
                            event.decisions.append(decisionTemp)
                            //print(event.decisions)
                            dismiss()
                            player.play()
                        }
                        .buttonStyle(BranchButton())
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(branchs) { branch in
                            Button(branch.name) {
                                decisionStamp(branch.jumpTo)
                                decisionTemp.answer = branch.name
                                event.decisions.append(decisionTemp)
                                //print(event.decisions)
                                dismiss()
                                player.play()
                            }
                            .buttonStyle(BranchButton())
                        }
                    }
                }
                .padding(1)
            }
            Spacer()
//            Button("Submit") {}
//                .buttonStyle(SendButton())
        }
        
    }
}

struct BranchButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(width: 200, height: 45)
            .foregroundColor(.primary)
            .background(.quinary)
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

struct SendButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(width: 175, height: 60)
            .foregroundColor(.white)
            .background(.blue)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

extension DecisionView {
    
    func decisionStamp(_ jumpTo: Int) {
        Task {
            withAnimation { showingNode = false }
            decisionTemp.endTime = dateTimeStamp()
            player.seek(to: CMTime(value: CMTimeValue(jumpTo * 10000000), timescale: 1000000000))
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
    
}
