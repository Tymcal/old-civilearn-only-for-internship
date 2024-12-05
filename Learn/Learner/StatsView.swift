//
//  StatsView.swift
//  Learn
//
//  Created by Teema Khawjit on 9/9/24.
//

import SwiftUI

struct StatsView: View {
    
    private var title: String = "Superconductors"
    private var duration: Float = 3071 //5.07.1
    private var question: String = "เมื่อแทนค่า u ไปแล้วได้?"
    private var correctAns: String = "B"
    
    @State private var currentScale: CGFloat = 5.0
    @State private var lastScaleValue: CGFloat = 5.0
    
    private var timestamps: [TestTimestamp] =
    [TestTimestamp(question: "Q1", timestamp: 1850),
     TestTimestamp(question: "Q2", timestamp: 2160),
     TestTimestamp(question: "Q3", timestamp: 2240),
     TestTimestamp(question: "Q4", timestamp: 2310),
     TestTimestamp(question: "Q5", timestamp: 2311),
     TestTimestamp(question: "Q6", timestamp: 2620),
     TestTimestamp(question: "เมื่อเจอกรณีนี้ต้องใช้สูตรอะไร", timestamp: 2730),
     TestTimestamp(question: "เมื่อแทนค่า t ไปแล้วได้?", timestamp: 2769),
     TestTimestamp(question: "เมื่อแทนค่า v ไปแล้วได้?", timestamp: 2791),
     TestTimestamp(question: "เมื่อแทนค่า u ไปแล้วได้?", timestamp: 2821),
     TestTimestamp(question: "จะได้ความเร่งเท่ากับ?", timestamp: 2905)
     
    ]
    
    private var correctCounts: [CorrectCount] =
    [CorrectCount(question: "Q1", count: 14),
     CorrectCount(question: "Q2", count: 4),
     CorrectCount(question: "Q3", count: 8),
     CorrectCount(question: "Q4", count: 12),
     CorrectCount(question: "Q5", count: 12),
     CorrectCount(question: "Q6", count: 13),
     CorrectCount(question: "เมื่อเจอกรณีนี้ต้องใช้สูตรอะไร", count: 9),
     CorrectCount(question: "เมื่อแทนค่า t ไปแล้วได้?", count: 10),
     CorrectCount(question: "เมื่อแทนค่า v ไปแล้วได้?", count: 1),
     CorrectCount(question: "เมื่อแทนค่า u ไปแล้วได้?", count: 3),
     CorrectCount(question: "จะได้ความเร่งเท่ากับ?", count: 6)
     
    ]
    
    private var totalLearner: CGFloat = 128
    private var totalLearned: CGFloat { return CGFloat(decisionStats.count) }
    private var decisionStats: [TestDecision] =
    [TestDecision(userId: "Teema K.", decision: "C", time: 45),
    TestDecision(userId: "Atikarn S.", decision: "B", time: 33),
    TestDecision(userId: "Supakorn P.", decision: "A", time: 33),
    TestDecision(userId: "Buchit S.", decision: "C", time: 20),
    TestDecision(userId: "Phurithat C.", decision: "C", time: 13),
    TestDecision(userId: "Nanthipat L.", decision: "C", time: 5),
    TestDecision(userId: "Anfield W.", decision: "C", time: 18),
    TestDecision(userId: "Nanthipat L.", decision: "C", time: 5),
    TestDecision(userId: "Ploysiri O.", decision: "A", time: 6),
    TestDecision(userId: "Jidapa R.", decision: "A", time: 21),
    TestDecision(userId: "Sippathinon C.", decision: "A", time: 15),
    TestDecision(userId: "Noppalak S.", decision: "C", time: 10),
    TestDecision(userId: "Setthakarn P.", decision: "B", time: 0.4),
    TestDecision(userId: "Napasin N.", decision: "B", time: 1),
    TestDecision(userId: "Patipol T.", decision: "D", time: 3)]
    
    private var decisionCounts: [DecisionCount] {
        return decisionStats.reduce(into: [DecisionCount]()) { counts, testDecision in
            if let index = counts.firstIndex(where: { $0.decision == testDecision.decision }) {
                counts[index].count += 1
            } else {
                counts.append(DecisionCount(decision: testDecision.decision, count: 1))
            }
        }
        .sorted{$0.decision < $1.decision}
    }
    
    private var mostCommonDecision: String {
        return decisionCounts.max(by: { $0.count < $1.count })!.decision
    }
    
    private var averageDecisionTime: Int {
        var total = 0.0
        for testDecision in decisionStats {
            total += testDecision.time
        }
        return Int(total)/decisionStats.count
    }
    
    private var learnTimeStats: [LearnTimeLog] =
    [LearnTimeLog(userId: "Teema K.", learnTime: 13),
     LearnTimeLog(userId: "Atikarn S.", learnTime: 13),
     LearnTimeLog(userId: "Supakorn P.", learnTime: 13),
     LearnTimeLog(userId: "Buchit S.", learnTime: 20),
     LearnTimeLog(userId: "Phurithat C.", learnTime: 13),
     LearnTimeLog(userId: "Nanthipat L.", learnTime: 12),
     LearnTimeLog(userId: "Anfield W.", learnTime: 18),
     LearnTimeLog(userId: "Nanthipat L.", learnTime: 13),
     LearnTimeLog(userId: "Ploysiri O.", learnTime: 21),
     LearnTimeLog(userId: "Jidapa R.", learnTime: 13),
     LearnTimeLog(userId: "Sippathinon C.", learnTime: 14),
     LearnTimeLog(userId: "Noppalak S.", learnTime: 10),
     LearnTimeLog(userId: "Setthakarn P.", learnTime: 13),
     LearnTimeLog(userId: "Napasin N.", learnTime: 13),
     LearnTimeLog(userId: "Patipol T.", learnTime: 15)]
    
    private var learnTimeCounts: [LearnTimeCount] {
        return learnTimeStats.reduce(into: [LearnTimeCount]()) { counts, learnTimeLog in
            if let index = counts.firstIndex(where: { $0.time == learnTimeLog.learnTime }) {
                counts[index].count += 1
            } else {
                counts.append(LearnTimeCount(time: learnTimeLog.learnTime, count: 1))
            }
        }
        .sorted{$0.time < $1.time}
    }
    
    private var mostCommonLearnTime: Int {
        return learnTimeCounts.max(by: { $0.count < $1.count })!.time
    }
    private var width = UIScreen.main.bounds.width
    private var fullWidth = UIScreen.main.bounds.width - 100
    
    var body: some View {
         ZStack {
            GradientBackground()
            VStack {
                HStack {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                //Overall Stats
//                VStack(alignment: .leading) {
//
//                    HStack(alignment: .center, spacing: 20) {
                        //Learned user
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text("เรียนแล้ว")
//                                        .font(.title2)
//                                    Spacer()
//                                    VStack(alignment: .leading) {
//                                        Text("\((totalLearned/totalLearner*100), specifier: "%.0f")%")
//                                            .font(.largeTitle)
//                                        .fontWeight(.bold)
//                                        Text("\(Int(totalLearned)) / \(Int(totalLearner))")
//                                            .font(.headline)
//                                    }
//                                }
//                                .padding()
//                                Spacer()
//                            }
//                            .frame(width: 140, height: 160)
//                            .background( .thinMaterial, in: RoundedRectangle(
//                                cornerRadius: 16.0))
                        
                        //Learning Time stats
//                            VStack(alignment: .leading) {
//                                HStack {
//                                    HStack {
//                                        Text("สถิติเวลาเรียน")
//                                            .font(.title2)
//                                            .frame(width: 100)
//                                        ForEach(0...23, id: \.self) {time in
//                                            VStack {
//                                                Spacer()
//                                                ForEach(learnTimeCounts) { learnTimeCount in
//                                                    if time == learnTimeCount.time {
//                                                        Rectangle()
//                                                            .frame(height: CGFloat(learnTimeCount.count)/CGFloat(learnTimeStats.count) * 50)
//                                                    }
//                                                }
//
//                                                Divider()
//                                                Text("\(time)")
//                                                    .frame(width: 21)
//                                            }
//
//                                        }
//
//                                    }
////                                    Spacer()
//                                }
//                                .padding()
//
//                            }
//                            .frame(height: 160)
//                            .background( .thinMaterial, in: RoundedRectangle(
//                                cornerRadius: 16.0))
                        
//                    }
//                    .padding()
//                }
//                .padding()
                
                //timeline
                ScrollView(.horizontal) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16.0)
                            .frame(width: width, height: 3)
                            .foregroundStyle(.tertiary)
                        HStack {
                            ForEach(correctCounts) {correctCount in
                                Text("\(Int(CGFloat(correctCount.count)/totalLearned*100))")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Int(CGFloat(correctCount.count)/totalLearned*100) < 76 && Int(CGFloat(correctCount.count)/totalLearned*100) > 50 ? .black.opacity(0.5) : .primary.opacity(0.75))
                                    .frame(width: 50, height: 50)
                                    .background(Int(CGFloat(correctCount.count)/totalLearned*100) > 75 ? Color(red: 29/255, green: 177/255, blue: 0/255) : Int(CGFloat(correctCount.count)/totalLearned*100) > 50 ? Color(red: 254/255, green: 174/255, blue: 0/255) : Int(CGFloat(correctCount.count)/totalLearned*100) > 25 ? Color(red: 242/255, green: 114/255, blue: 0/255) : Int(CGFloat(correctCount.count)/totalLearned*100) > 0 ? Color(red: 181/255, green: 23/255, blue: 0/255) : .gray, in: RoundedRectangle(cornerRadius: 13.0))
                            }
                        }
                    }
                    .frame(height: 100)
                }
                .disabled(CGFloat(correctCounts.count*54) < width)
                
                Spacer()
                
                //Node stats detail
                VStack {
                    HStack {
                        Text(question)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button("Edit now") {
                            
                        }
                        .padding()
                        .foregroundStyle(.primary)
                        .buttonStyle(.bordered)
//                        .background(.tertiary, in: RoundedRectangle(cornerRadius: 7.0))
                        
                    }
                    Divider()
                    
                    //Overall decision count
                    HStack {
                        VStack(alignment: .leading, spacing: -5) {
                            ForEach(decisionCounts) { decisionCount in
                                HStack {
                                    Text("\(decisionCount.decision)")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .frame(width: 25)
                                    Rectangle()
                                        .foregroundStyle(decisionCount.decision == mostCommonDecision ? (decisionCount.decision == correctAns ? .green : .red) : .secondary)
                                        .frame(width: decisionCount.count/CGFloat(decisionStats.count) * fullWidth, height: 30)
                                }
                            }
                        }
                        Spacer()
                    }
                    HStack {
                        //Longest
                        VStack(alignment: .leading) {
                            Text("นานสุด")
                                .foregroundColor(.secondary)
                            ForEach(
                                Array(decisionStats
                                    .sorted(by: { $0.time > $1.time})
                                    .prefix(3)),
                                id: \.self) { slowest in
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Text("\(slowest.decision) \(slowest.userId)")
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text(
                                            //check if time ist integer or decimal
                                            floor(slowest.time) == slowest.time
                                            ?
                                            "\(Int(slowest.time))"
                                            :
                                                //if decimal, show only 1 place
                                                "\(slowest.time, specifier: "%.1f")")
                                            .foregroundColor(.primary)
                                    }
                                    .padding()
                                    .frame(width: 300)
                                        
                                }
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [
                                        slowest.decision == correctAns ?
                                        Color(red: 29/255, green: 117/255, blue: 0/255) : Color(red: 181/255, green: 23/255, blue: 0/255), Color.clear]), startPoint: .bottomLeading, endPoint: .topTrailing),
                                              in: RoundedRectangle(
                                                cornerRadius: 16.0
                                              )
                                            )
                                .overlay(RoundedRectangle(cornerRadius: 16.0)
                                    .strokeBorder(Color.secondary, lineWidth: 1.0
                                ))
                            }
                        }
                        Spacer()
                        //Average time
                        VStack {
                            Text("เวลาตัดสินใจเฉลี่ย")
                                .font(.title)
                                .foregroundStyle(.secondary)
                                .fontWeight(.light)
                            Text("\(averageDecisionTime) วินาที")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        
                        //Shortest
                        VStack(alignment: .trailing) {
                            Text("เร็วสุด")
                                .foregroundColor(.secondary)
                            ForEach(
                                Array(decisionStats
                                    .sorted(by: { $0.time < $1.time})
                                    .prefix(3))
                                , id: \.self) { fastest in
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Text("\(fastest.decision) \(fastest.userId)")
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text(
                                            //check if time ist integer or decimal
                                            floor(fastest.time) == fastest.time
                                            ?
                                            "\(Int(fastest.time))"
                                            :
                                                //if decimal, show only 1 place
                                                "\(fastest.time, specifier: "%.1f")")
                                            .foregroundColor(.primary)
                                    }
                                    .padding()
                                    .frame(width: 300)
                                        
                                }
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [
                                        fastest.decision == correctAns ?
                                        Color(red: 29/255, green: 117/255, blue: 0/255) : Color(red: 181/255, green: 23/255, blue: 0/255), Color.clear]), startPoint: .bottomLeading, endPoint: .topTrailing),
                                              in: RoundedRectangle(
                                                cornerRadius: 16.0
                                              )
                                            )
                                .overlay(RoundedRectangle(cornerRadius: 16.0)
                                    .strokeBorder(Color.secondary, lineWidth: 1.0
                                ))
                            }
                        }
                    }
                }
                .padding(30)
                .background(.thinMaterial)
            }
        }
        
    }
}

#Preview {
    StatsView()
        .environment(\.colorScheme, .dark)
}

struct GradientBackground: View {
    var body: some View {
        LinearGradient(gradient: gradient, startPoint: .bottomLeading, endPoint: .topTrailing)
            .ignoresSafeArea()
    }
    static let blue = Color(red: 2/255, green: 17/255, blue: 26/255);
    static let purple = Color(red: 111/255, green: 72/255, blue: 163/255);
    static let red = Color(red: 26/255, green: 10/255, blue: 18/255);
    
    let gradient = Gradient(colors: [blue, red])
}


//    .linearGradient(
//        gradient: Gradient(colors: [
//            Color.secondary,
//            Color(red: 181/255, green: 23/255, blue: 0/255),
//        ]), startPoint: .leading, endPoint: .trailing)
