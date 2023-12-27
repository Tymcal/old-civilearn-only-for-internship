//
//  SwiftUIView.swift
//  Learn
//
//  Created by Teema Khawjit on 8/17/23.
//

import SwiftUI
import PhotosUI
import AVKit

struct SwiftUIView: View {

    @State private var modelData = ModelData()
    @State private var showingTitle = false
    @State private var title = ""
    @State private var asset = ""
    @State private var nodes = [Node]()
    
    @State private var showingUploadPath = false
    @State private var selectedItem: PhotosPickerItem?
    
    enum LoadState {
            case unknown, loading, loaded(Movie), failed
        }
    @State private var loadState = LoadState.unknown
    var body: some View {
        VStack {
            Button {
                showingTitle = true
            } label: {
                Text("Add")
            }
        }
        .alert("Name the Title", isPresented: $showingTitle) {
            TextField("Title", text: $title)
            Button("Done") {
                let newContent = Draft(title: title, asset: asset, nodes: nodes)
                modelData.addContent(newContent)
                title = ""
                asset = ""
                nodes = [Node]()
                showingUploadPath = true
            }
            Button("Cancel", role: .cancel) {}
        }
    
        //UPLOAD VIDEO PATH
        .alert("Upload Video from", isPresented: $showingUploadPath) {
            Button("Files") {
                
            }
            PhotosPicker(selection: $selectedItem, matching: .videos, photoLibrary: .shared()) {
                Text("Photos")
            }
            
            switch loadState {
            case .unknown:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let movie):
                VideoPlayer(player: AVPlayer(url: movie.url))
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            case .failed:
                Text("Import failed")
            }
            
            Button("Cancel", role: .cancel) {}
        }
        
        .onChange(of: selectedItem) { _ in
            Task {
                do {
                    loadState = .loading

                    if let movie = try await selectedItem?.loadTransferable(type: Movie.self) {
                        loadState = .loaded(movie)
                    } else {
                        loadState = .failed
                    }
                } catch {
                    loadState = .failed
                }
            }
        }
    }
    
        
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

struct Movie: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "movie.mp4")

            if FileManager.default.fileExists(atPath: copy.path()) {
                try FileManager.default.removeItem(at: copy)
            }

            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
    }
}
