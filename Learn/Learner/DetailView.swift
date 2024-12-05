//
//  DetailView.swift
//  Learn
//
//  Created by Teema Khawjit on 11/7/24.
//
import SwiftUI

struct DetailView: View {
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Text("s")
                    ForEach(0..<images.count, id: \.self) { index in
                    }
                }
            }
        }
    }
}

#Preview {
    DetailView()
}
