//
//  DocorgView.swift
//  Learn
//
//  Created by Teema Khawjit on 6/9/23.
//

import SwiftUI

struct DocorgView: View {
    @State private var tiles: [Tile] = []
    
    init() {
        
    }
    
    var body: some View {
        VStack {
            Text("Document Organization")
                .font(.largeTitle)
                .navigationTitle("Document Organization")
            ScrollView([.horizontal, .vertical]) {
                HStack {
                    ForEach(tiles, id: \.id) { tile in
                        TileView(tile: tile, type: 0)
                    }
                    TitleTile()
                    Menu("+") {
                        Button {
                            addTile()
                        } label: {
                            Label("Title", systemImage: "character.cursor.ibeam")
                        }
                        
                        Button {
                            addExample()
                        } label: {
                            Label("Example", systemImage: "abc")
                        }
                        
                        Button {
                            addMechanism()
                        } label: {
                            Label("Mechanism", systemImage: "gear")
                        }
                        
                        Button {
                            addEquation()
                        } label: {
                            Label("Equation", systemImage: "function")
                        }
                        
                        Button {
                        } label: {
                            Label("Definition", systemImage: "text.below.photo")
                        }
                    }
                    .fontWeight(.bold)
                    .frame(width: 20, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    Add(type: "side")
                }
            }
        }
    }
        func addTile() {
            let newTile = Tile()
            tiles.append(newTile)
        }
}

struct TitleTile: View {
    //var text: String
    @State var title = ""
    @State var placeholder = "Unnamed section"
    @State private var showingAlert = false
    var body: some View {
        Button(placeholder) {
            showingAlert = true
        }
            .fontWeight(.bold)
            .frame(width: 250, alignment: .leading)
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        
            .alert("Rename", isPresented: $showingAlert) {
                TextField("Title", text: $title)
                Button("Done") {
                    if title == "" {
                        placeholder = "Unnamed section"
                    } else {
                        placeholder = title
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        
            .contextMenu {
                Button("Delete", role: .destructive, action: deleteTile)
            }
    }
    
}

struct Add: View {
    let type: String
    var body: some View {
        Menu("+") {
            Button("Title", action: addTitle)
            Button("Example", action: addExample)
            Button("Mechanism", action: addMechanism)
            Button("Equation", action: addEquation)
            Button("Definition", action: addDefinition)
        }
            .fontWeight(.bold)
            .frame(width: 20, alignment: .center)
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        
        if type == "Side" {
            
        }
        
        if type == "Down" {
            
        }
            
    }
}


struct DefinitionView: View {
    //var definition: Definition
    var body: some View {
        VStack {
            
            //Text(definition.title)
            //Text(definition.description)
        }
    }
}
struct TileView: View {
    let tile: Tile
    let type: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            //Text("Tile \(tile.id)")
            switch type {
            case 0:
                TitleTile()
            case 4:
                DefinitionView()
            default:
                TitleTile()
            }
            
            Add(type: "Down")
        }
    }
}
func addTitle() {}
func addExample() {}
func addMechanism() {}
func addEquation() {}
func addDefinition() {}



func deleteTile() {}



struct DocorgView_Previews: PreviewProvider {
    static var previews: some View {
        DocorgView()
    }
}
