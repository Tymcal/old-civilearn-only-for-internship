//
//  EditView.swift
//  Learn
//
//  Created by Teema Khawjit on 7/15/23.
//

import SwiftUI
import AVKit

struct EditView: View {
    var content: Draft
    var body: some View {
        NavigationStack {
            HStack {
                MediaView(fileName: content.asset)
                    .frame(width: UIScreen.main.bounds.width * (0.5))
                DecisionList(draft: content)
                    .frame(width: UIScreen.main.bounds.width * (0.5))
                    //.environmentObject(ContentData())
            }
        }
        //.navigationTitle(content.title)
    }
}

struct MediaView: View {
    var fileName: String = "IMG_4966"
    @State private var addButtonEnable = false
    @State private var timestamp: Double = 0.00
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "MOV")!))
        VStack {
            VideoPlayer(player: player)
                .onAppear {
                    
                    player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                        print(CMTimeGetSeconds(player.currentTime()))
                        if player.timeControlStatus == .paused {
                            timestamp = CMTimeGetSeconds(player.currentTime())
                            print(timestamp)
                            //addButtonEnable = true
                        }
                        }
                    
                }
                .frame(width: 544, height: 306)
            Button {
                print(timestamp)
            } label: {
                Image(systemName: "plus")
            }
            //.disabled(!addButtonEnable)
            .buttonStyle(.borderedProminent)
            .cornerRadius(20)
        }
        
    }
}

struct DecisionList: View {
    @ObservedObject private var modelData = ModelData()
    @State var draft: Draft
    @State private var showingNewDecision = false
    @State private var name = ""
    @State private var timestamp = 0.00
    @State private var branchs = [Branch]()
    var body: some View {
        List(draft.nodes) { decision in
            NavigationLink {
                DecisionDetail(content: draft, decision: decision)
            } label: {
                DecisionRow(decision: decision)
            }
        }
        .navigationTitle(draft.title)
        .navigationBarTitleDisplayMode(.large)
        
        .toolbar {
            //ADD BUTTON
            Button {
                showingNewDecision = true
            } label: {
                Image(systemName: "plus")
            }
        }
        
        //NAME THE QUESTION
        .alert("Name the Title", isPresented: $showingNewDecision) {
            TextField("Question", text: $name)
            TextField("Timestamp", value: $timestamp, formatter: NumberFormatter())
            Button("Done") {
                let newDecision = Node(name: name, timestamp: timestamp, branchs: branchs)
                modelData.addDecision(draft, newDecision)
                name = ""
                timestamp = 0.00
                branchs = [Branch]()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

struct DecisionRow: View {
    var decision: Node
    var body: some View {
        HStack {
            Text(decision.name)
                .font(.title)
            Spacer()
            Text(String(decision.timestamp))
                .font(.subheadline)
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(content: ModelData().drafts[0])            .previewInterfaceOrientation(.landscapeLeft)
    }
}
