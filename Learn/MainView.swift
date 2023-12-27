//
//  HomeView.swift
//  Learn
//
//  Created by Teema Khawjit on 6/9/23.
//

import SwiftUI
import PhotosUI

struct MainView: View {
    @State private var isShowingAlert = false
    @State private var newItem = ""
    @State private var navigateToDocorgView = false    
    var body: some View {
        TabView {
//            HomeView()
//                .tabItem {
//                    Label("Learn", systemImage: "house")
//                }
                
            CreateView()
                .tabItem {
                    Label("Create", systemImage: "slider.horizontal.below.rectangle")
                }
                .navigationTitle("Home")
                .toolbar {
                    Menu {
                        Button {
                            // Add this item to a list of favorites.
                        } label: {
                            Label("Add to Favorites", systemImage: "heart")
                        }
                        Button {
                            // Open Maps and center it on this item.
                        } label: {
                            Label("Show in Maps", systemImage: "mappin")
                        }
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
        }
    }
}


struct ShowcaseView: View {
    @ObservedObject var modelData = ModelData()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(modelData.drafts) { content in
                    NavigationLink {
                        EditView(content: content)
                    } label: {
                        ContentGrid(title: content.title)
                            .contextMenu {
                                Button("Delete", role: .destructive, action: {
                                    modelData.deleteContent(content)
                                })
                            }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ContentGrid: View {
    let title: String
    
    var body: some View {
        Button(title) {
            
        }
        .frame(width: 352, height: 198)
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .background(LinearGradient(gradient: gradient, startPoint: .bottomLeading, endPoint: .topTrailing)
)
    }
    
    static let color0 = Color(red: 1/255, green: 96/255, blue: 250/255);
            
    static let color1 = Color(red: 111/255, green: 72/255, blue: 163/255);

    static let color2 = Color(red: 239/255, green: 45/255, blue: 84/255);
    
    let gradient = Gradient(colors: [color0, color1, color2])
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
            .previewInterfaceOrientation(.landscapeLeft)
        MainView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
