//
//  MapView.swift
//  Learn
//
//  Created by Teema Khawjit on 3/30/23.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.mint, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
                .edgesIgnoringSafeArea(.all)
            MapButton()
        }
    }
}

struct MapButton: View {
    
    var chapter: String = "Chapter"
    var section: String = "sectionnnn"+"  "
    
    var body: some View {
            HStack(spacing: 15) {
                Circle()
                    .stroke(Color.secondary, lineWidth: 4)
                    .frame(width: 35, height: 35)
                VStack(alignment: .leading) {
                    Text(chapter)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(section)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                }
                
            }
            .padding(.horizontal)
            .padding(.vertical, 13)
            .opacity(0.5)
            .background(Blur(style: .systemMaterialLight))
            .cornerRadius(32)
        
    }
}
    
struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
