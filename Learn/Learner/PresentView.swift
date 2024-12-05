//
//  PresentView.swift
//  Learn
//
//  Created by Teema Khawjit on 9/4/24.
//

import SwiftUI
import Foundation

struct CurrentView: View {
    @State private var mainTab = 1 // Set the default tab to the second tab
    var body: some View {
        TabView(selection: $mainTab) {
            PastView()
                .tabItem {
                    Image(systemName: "backward")
                    Text("Past")
                }
                .tag(0)
            PresentView()
                .tabItem {
                    Image(systemName: "dot.circle")
                    Text("Present")
                }
                .tag(1)
            FutureView()
                .tabItem {
                    Image(systemName: "forward")
                    Text("Future")
                }
                .tag(2)
        }
        .ignoresSafeArea()
        .tabViewStyle(.tabBarOnly)
    }
}

struct PresentView: View {
    
    private var testUser: TestUser = TestUser(
        firstname: "Teema",
        lastname: "Khawjit",
        email: "teema.khawjit@gmail.com",
        pswd: "12345678",
        birthdate: "18122003",
        contact: 
            Contact(
                line: "",
                messenger: "",
                tel: ""),
        stats: [],
        exp: 500,
        past: [],
        present: [
        ],
        future: ["0001", "0002"],
        contribution: [])
    
    private var testEvent: [TestEvent] = [
        TestEvent(title: "Cloud", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 0, start: 13, end: 16)),
        TestEvent(title: "AI", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 1, start: 8.5, end: 12.5)),
        TestEvent(title: "IoT Lab", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 1, start: 13, end: 16)),
        TestEvent(title: "Test Test", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 1, start: 17, end: 20)),
        TestEvent(title: "Math", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 2, start: 13, end: 17)),
        TestEvent(title: "Seminar", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 3, start: 13, end: 16)),
        TestEvent(title: "Chinese", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 3, start: 16, end: 19)),
        TestEvent(title: "Software Engineering", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 4, start: 8, end: 12)),
        TestEvent(title: "Social Ent", isPlaying: false, contPlaying: 0, dateAdded: "", learnTime: LearnTime(day: 4, start: 13, end: 16)),
    ]
    
    var body: some View {
        Schedule(events: testEvent)
    }
}

struct Schedule : View {
    
    var events: [TestEvent]
    init(events: [TestEvent]) {
        self.events = events
    }
    
//    private var days: [String] = ["จ", "อ", "พุ", "พ", "ศ", "ส", "อ"]
    private var width = UIScreen.main.bounds.width
    
    private var todayDay: Int {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let date = Int(dateFormatter.string(from: today)) ?? 0
        return date
    }
    
    private var daysOfWeek: [(dom: Int, dow: String)] {
        return getDaysOfCurrentWeekWithFirstLetter()
    }
    
    private var widthCell: CGFloat = 43
    private var heightCell: CGFloat = 80
    
    private var earliestClass: CGFloat {
        var earliestHour: [CGFloat] = []
        for event in events {
            earliestHour.append(event.learnTime.start)
        }
        return earliestHour.min() ?? 8
    }
    
    private var latestestClass: CGFloat {
        var latestHour: [CGFloat] = []
        for event in events {
            latestHour.append(event.learnTime.end)
        }
        return latestHour.max() ?? 20
    }
    
    private var allEventFiltered: [[TestEvent]] {
        var x: [[TestEvent]] = []
        //seperate by day
        for day in daysOfWeek.indices {
            x.append(events.filter({$0.learnTime.day == CGFloat(day)}))
        }
        return x
    }
    
    private var allEndClasses: [[CGFloat]] {
        var x: [[CGFloat]] = []
        for day in daysOfWeek.indices {
            var startEachDay: [CGFloat] = [earliestClass]
            for event in events.filter({$0.learnTime.day == CGFloat(day)}) {
                startEachDay.append(event.learnTime.end)
            }
            //eliminate duplicate value in case first class of tht day is as same as earliestClass variable
            x.append(startEachDay)
        }
        return x
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
            ScrollView(.horizontal) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 0) {
                                Text("")
                                    .frame(width: 60)
                                ForEach(stride(from: earliestClass, through: latestestClass, by: 1).map { $0 }, id: \.self) { time in
                                    HStack {
                                        Text("\(Int(time))")
                                        Spacer()
                                    }
                                    .frame(width: 2*widthCell)
                                }
                            }
                            
                            Divider()
                            
                            ForEach(daysOfWeek.indices, id: \.self) { day in
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading, spacing: -7) {
                                        Text("\(daysOfWeek[day].dow)")
                                        Text("\(daysOfWeek[day].dom)")
                                    }
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(daysOfWeek[day].dom == todayDay ? .primary : .secondary)
                                    .frame(width: 60, height: heightCell)
                                    ForEach(allEventFiltered[day]) {
                                        event in
                                        
                                        ForEach(allEventFiltered[day].indices, id: \.self) { i in
                                            
                                            if event.learnTime.end == allEndClasses[day][i+1] {
                                                //Blank (no-class) Area
                                                Rectangle()
                                                    .foregroundStyle(.clear)
                                                    .frame(width: widthCell*(
                                                        event.learnTime.start
                                                        -
                                                        allEndClasses[day][i]
                                                    )*2, height: heightCell)
                                                
                                                //Title
                                                Button {
                                                    
                                                } label: {
                                                    Text(("\(event.title)"))
                                                        .font(.title2)
                                                        .fontWeight(.semibold)
                                                        .foregroundStyle(
                                                            daysOfWeek[day].dom == todayDay
                                                                ?
                                                            
                                                                .black.opacity(0.9)
                                                            :
                                                                    .white)
                                                        .frame(width: widthCell*(
                                                            event.learnTime.end
                                                            -
                                                            event.learnTime.start
                                                        )*2, height: heightCell)
                                                        .background(
                                                            daysOfWeek[day].dom == todayDay
                                                            ?
                                                            Color.white.opacity(0.9)
                                                            :
                                                            Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 5.0))
                                                }
                                            }
                                        }
                                    }
                                }
                                Divider()
                            }
                        }
            }
            .disabled(2*widthCell*(latestestClass-earliestClass) + widthCell < width)
        }
    }
}

#Preview {
    CurrentView()
        .environment(\.colorScheme, .dark)
//    PresentView()
//        .environment(\.colorScheme, .dark)
}

extension Schedule {

    func getDaysOfCurrentWeekWithFirstLetter() -> [(dom: Int, dow: String)] {
        let calendar = Calendar.current
        let today = Date()

        // Find the start of the week (Monday)
        let startOfWeek = calendar.date(byAdding: .day, value: -calendar.component(.weekday, from: today) + 2, to: today)

        // Generate days of the month and first letter for the entire week (Monday to Sunday)
        var weekInfo: [(dom: Int, dow: String)] = []
        var date = startOfWeek!

        for _ in 0..<7 {
            let dom = calendar.component(.day, from: date) // Extract day of the month
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"  // Get the full name of the day
            let dayOfWeek = formatter.string(from: date) // Get the day of the week
            let dow = String(dayOfWeek.prefix(1)) // Get the first letter of the day

            weekInfo.append((dom, dow))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }

        return weekInfo
    }

}
