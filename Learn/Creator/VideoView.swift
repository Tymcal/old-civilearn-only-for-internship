//
//  VideoView.swift
//  Learn
//
//  Created by Teema Khawjit on 7/17/23.
//

import AVKit
import PhotosUI
import SwiftUI

struct VideoView: View {
    enum LoadState {
            case unknown, loading, loaded(Movie), failed
        }

        @State private var selectedItem: PhotosPickerItem?
        @State private var loadState = LoadState.unknown

        var body: some View {
            VStack {
                PhotosPicker("Select movie", selection: $selectedItem, matching: .videos, photoLibrary: .shared())

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

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
    }
}
