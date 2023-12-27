//
//  DecisionView.swift
//  Learn
//
//  Created by Teema Khawjit on 6/28/23.
//

import SwiftUI

struct DecisionDetail: View {
    @ObservedObject private var modelData = ModelData()
    @State var content: Draft
    @State var decision: Node
    
    @State private var isEditing = false
    @State private var isCreator = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                if isEditing {
                    TextField("", text: $decision.name)
                        .font(.largeTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            isEditing = false
                            //modelData.updateDecision(content, decision)
//                            $modelData.decisions[decisionIndex].question = $decision.question
                        }
                        .submitLabel(.done)
                } else {
                    Text(decision.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .onTapGesture {
                            isEditing = true
                        }
                }
                Spacer()
            }
            Spacer()
            VStack(alignment: .leading) {
                ForEach(decision.branchs) { option in
                    OptionView(content: content,
                               decision: decision,
                               option: option)
                }
                HStack(alignment: .center) {
                    Spacer()
                    Button() {
                        dismiss()
                    } label: {
                        Text("Submit")
                            .padding(20)
                            .frame(width: 200)
                    }
                    .fontWeight(.bold)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding (10)
                    .disabled(isCreator)
                    Spacer()
                }
            }
        }
        .padding(50)
        .background(.thinMaterial)
        .cornerRadius(10)
        
    }
}

struct OptionView: View {
    @ObservedObject private var modelData = ModelData()
    @State var content: Draft
    @State var decision: Node
    @State var option: Branch
    @State private var name = ""
    @State private var toRename = false
    @State private var isCreator = false
    @State private var isTapped = false
    
    @State private var answer = ""
    
    var body: some View {
        HStack {
            Button {
                if isCreator {
                    //tap to rename option
                    toRename = true
                    
                    answer = option.name
                }
            } label: {
                Text(option.name)
                Spacer()
                
                //JUMP
                Button {
                } label: {
                    Text(option.jumpTo)
                        .padding(6)
                        .frame(width: 65)
                }
                
                    .background(.quaternary)
                    .font(.subheadline)
                    .cornerRadius(15)
                    .buttonStyle(.borderless)
                
                    //hide jump view in learner mode
                    .opacity(isCreator ? 1 : 0)
                    .disabled(!isCreator)
            }
                //option button
                .fontWeight(.bold)
                .frame(alignment: .leading)
                .padding()
                .background(isTapped ? .blue : .white)
                .foregroundColor(isTapped ? .white : .blue)
                .cornerRadius(10)
                .disabled(!isCreator)
                .onTapGesture {
                    isTapped.toggle()
                }
            //rename option.name
                .alert("Rename", isPresented: $toRename) {
                    TextField("new name", text: $option.name)
                    Button("Done") {
                        //modelData.updateOption(content, decision, option)
                    }
                    Button("Cancel", role: .cancel) {}
                }
                
        }
    }
}

struct DecisionDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        DecisionDetail(content: modelData.drafts[0], decision: modelData.drafts[0].nodes[0])
            //.environmentObject(contentData)
            .frame(width: 600, height: 500)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
