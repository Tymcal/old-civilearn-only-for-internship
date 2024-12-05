//
//  CreateView.swift
//  Learn
//
//  Created by Teema Khawjit on 12/22/23.
//

import SwiftUI
import PhotosUI

struct CreateView: View {
    
    @StateObject private var modelData = ModelData()
    @State var selectedItems: [PhotosPickerItem] = []
    @State private var showingTitle = false
    @State private var showingUploadPath = false
    @State private var title = ""
    @State private var video = ""
    @State private var decisions = [Node]()
    var body: some View {
        NavigationStack {
            ShowcaseView()
                .padding(10)
                .navigationTitle("Create")
                .toolbar {
                    //ADD BUTTON
                    Button {
                        showingTitle = true
                    } label: {
                        Image(systemName: "plus")
                    }
//                    ProfileButton(isLoggedIn: $isLoggedIn, token: $token)
                }
            
                //NAME THE TITLE ALERT
                .alert("Name the Title", isPresented: $showingTitle) {
                    TextField("Title", text: $title)
                    Button("Done") {
                        let newContent = Draft(title: title, asset: video, nodes: decisions)
                        modelData.addContent(newContent)
                        title = ""
                        video = ""
                        decisions = [Node]()
                        showingUploadPath = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
            
                //UPLOAD VIDEO PATH
                .alert("Upload Video from", isPresented: $showingUploadPath) {
                    Button("Files") {
                        
                    }
                    PhotosPicker("Photos", selection: $selectedItems, matching: .videos)
                    Button("Cancel", role: .cancel) {}
                }
        }
    }
}

#Preview {
    CreateView()
}
