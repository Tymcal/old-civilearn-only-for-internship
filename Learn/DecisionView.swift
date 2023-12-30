//
//  DecisionView.swift
//  Learn
//
//  Created by Teema Khawjit on 12/26/23.
//

import SwiftUI
import AVKit

struct DecisionView_test: View {
    
    private var content: Content =
    Content(title: "Mechanhics",
            asset: "test",
            nodes: [
                Node(id: "1", name: "Q1",
                     timestamp: 5.00,
                     branchs: [
                        Branch(id: "1", name: "2014", jumpTo: 0.07),
                        Branch(id: "2", name: "2012", jumpTo: 0.23),
                        Branch(id: "3", name: "2023", jumpTo: 0.07),
                        Branch(id: "4", name: "2017", jumpTo: 0.07),
//                        Branch(id: "5", name: "2011", jumpTo: "0:07"),
//                        Branch(id: "6", name: "2018", jumpTo: "0:07"),
//                        Branch(id: "7", name: "2020", jumpTo: "0:07"),
//                        Branch(id: "8", name: "2024", jumpTo: "0:07"),
                     ]),Node(id: "2", name: "Q1",
                            timestamp: 15.00,
                            branchs: [
                                Branch(name: "2014", jumpTo: 0.07),
                                Branch(name: "2012", jumpTo: 0.23),
                                Branch(name: "2023", jumpTo: 0.07),
                                Branch(name: "2017", jumpTo: 0.07),
                            ]),
            ]
    )
    
    private var width: CGFloat = UIScreen.main.bounds.width
    
    private var fileName: String = "IMG_4966"
    
    @State private var showingNode: Bool = false
    
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "MOV")!))
        
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .ignoresSafeArea()
            VideoPlayer(player: player)
                .allowsHitTesting(true)
                .frame(width: width, height: width*9/16)
            VStack {
                Spacer()
//                DecisionView(branchs: content.nodes[0].branchs[0], showingNode: $showingNode)
//                    .frame(width: width*0.965, height: 60)
//                    //.blur(radius: 20, opaque: true)
//                    .background(.thickMaterial)
//                    .cornerRadius(10)
            }
        }
    }
}

struct DecisionView: View {
    @Binding var branchs: [Branch]
    @Binding var showingNode: Bool
    var body: some View {
        HStack {
            Spacer()
            if branchs.count < 5 {
                HStack {
                    ForEach(branchs) { branch in
                        Button(branch.name) {
                            withAnimation { showingNode = false }
                        }
                        .buttonStyle(BranchButton())
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(branchs) { branch in
                            Button(branch.name) {
                                withAnimation { showingNode = false }
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
            .foregroundColor(.black)
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

#Preview {
    DecisionView_test()
}
