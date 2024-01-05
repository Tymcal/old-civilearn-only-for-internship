import SwiftUI
import Foundation
import AVKit

struct testfield: View {
    @State private var events: [Event] = [
                Event(
                    id: "1",
                    title: "Mechanics",
                    asset: "4871.MOV",
                    decisions: [],
                    creator: Creator(firstname: "Prabpon", lastname: "Phraiphimuk")),
                    
                Event(
                    id: "2",
                    title: "Wave",
                    asset: "4872.MOV",
                    decisions: [],
                    creator: Creator(firstname: "Pornnapat", lastname: "Chattananan")),
                
                Event(
                    id: "3",
                    title: "Electricity",
                    asset: "4873.MOV",
                    decisions: [],
                    creator: Creator(firstname: "Pasawat", lastname: "Khumpeera")),
                
                Event(
                    title: "Thermodynamics",
                    asset: "4874.MOV",
                    decisions: [],
                    creator: Creator(firstname: "Tim", lastname: "Cook"))
            ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(events) { event in
                        NavigationLink {
                            LobbyView(event: event, prevPage: .homeView)
                        } label: {
                            GridView_test(event: event)
                                .contextMenu {
                                    Button("Delete", role: .destructive, action: {
                                        
                                    })
                                }
                                .border(Color.secondary, width: 0.25)
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(width: 1080)
            }
            .padding(.horizontal)
            .navigationTitle("Home")
            .toolbar {
                Button {
                } label: {
                    Image(systemName: "plus")
                }
                Image(systemName: "person.circle").foregroundColor(.blue)
            }
        }
    }
}

struct GridView_test: View {
    @State var event: Event
    var body: some View {
        Button(event.title) {
            
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

struct LobbyView: View {
    @State var event: Event
    @State var prevPage: PrevPage
    //@Binding var token: String
    var body: some View {
        VStack {
            Text(event.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(25)
            HStack {
                if prevPage == .homeView {
                    NavigationLink(destination: PlayerView(content: <#Content#>)) {
                        Button("Play") {}
                        .buttonStyle(ShortBigButton(background: .blue))
                    }
                } else {
                    Button("Resume") {
                        
                    }
                    .buttonStyle(ShortBigButton(background: .blue))
                    
                    Button("Help!") {
                        
                    }
                    .buttonStyle(ShortBigButton(background: .primary, foreground: .blue))
                    
                    Button("Leave") {
                        
                    }
                    .buttonStyle(ShortBigButton(background: .primary, foreground: .red))
                }
                
            }
        }
    }
}

struct ShortBigButton: ButtonStyle {
    @State var background: Color
    @State var foreground: Color?
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(width: 200, height: 60)
            .foregroundColor(foreground ?? .white)
            .background(background)
            .cornerRadius(20)
    }
}

#Preview {
    //testfield()
    LobbyView(
        event: Event(title: "Test", asset: "https", decisions: [], creator: Creator(firstname: "Teema", lastname: "Khawjit")), prevPage: .homeView
    )
}
