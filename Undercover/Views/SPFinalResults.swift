//
//  SPFinalResults.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import SwiftUI
import SwiftData
import MusicKit

struct SPFinalResults: View {
    @Environment(SinglePlayerGameController.self) var gameController
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\UCHiScoreEntry.date, order: .reverse)]) var hiScores: [UCHiScoreEntry]
    @State private var thisScore: UCHiScoreEntry? = nil
    @State private var isNewHiScore = true // TODO: Change back
    @State private var hiScoreNoticeShouldFlash = false
    @State private var highestScore: UCHiScoreEntry?
    @State private var currentGameScores: [UCHiScoreEntry]? = []
    
    @AppStorage("secondsPerRound") var secondsPerRound: Int = 30
    
    let onEndGame: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("GAME OVER")
                    .font(.largeTitle)
                    .italic()
                    .fontWeight(.black)
                    
                if thisScore?.score ?? 0 > 0 {
                    Image("victory1")
                        .resizable().scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 2)
                }
                
                VStack(spacing:-10) {
                    Text("YOU GOT")
                        .font(.custom(Font.customFontName, size: 16))
                    Text("\(thisScore?.score ?? 0)")
                        .font(.custom(Font.customFontName, size: 72))
                    Text("POINTS TOTAL")
                        .font(.custom(Font.customFontName, size: 16))
                }
                .fontDesign(.none)
                
                if isNewHiScore {
                    Text("New Hi Score!")
                        .fontDesign(.none)
                        .font(.custom(Font.customFontName, size: 46))
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background {
                            Capsule().stroke(Color.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [10], dashPhase: 100))
                                
                        }
                        .foregroundStyle(Color.accentColor)
                        .animation(Animation.snappy(duration: 0.3).repeatForever()) { view in
                            view.opacity(hiScoreNoticeShouldFlash ? 0 : 1)
                        }
                }
                
//                if let scores = currentGameScores {
//                    VStack {
//                        ForEach(scores.enumerated(), id: \.1.id) { (iteration, score) in
//                            HStack(spacing: 12) {
//                                Text("1")
//                                    .padding()
//                                    .foregroundStyle(.primary).colorInvert()
//                                    .background {
//                                        Circle()
//                                            .foregroundStyle(.tertiary)
//                                            .shadow(radius: 2, x: 1, y: 1)
//                                    }
//                                    .fontWeight(.black)
//                                Text("493pts, 2/3/34 2:34pm")
//                                    .fontWeight(.medium)
//                            }
//                        }
//                        
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background {
//                        RoundedRectangle(cornerRadius: 5)
//                            .foregroundStyle(.quaternary)
//                    }
//                }
                
                VStack(spacing: 8) {
                    ForEach(gameController.pastAnswers) { album in
                        BasicAlbumCard(ucAlbum: album)
                    }
                }
                
                Button("Done") {
                    onEndGame()
                }
                .bold()
                .buttonStyle(PillButtonStyle())
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .onAppear {
                if let category = gameController.category {
                    let newEntry = UCHiScoreEntry(categoryID: category.id, score: gameController.points, rounds: gameController.rounds, secondsPerRound: secondsPerRound, numberOfOptions: gameController.numberOfOptions)
                    thisScore = newEntry
                    modelContext.insert(newEntry)
                    
                    currentGameScores = gameController.hiScoresForCurrentGame(fromScores: hiScores)?.sorted(using: [SortDescriptor(\UCHiScoreEntry.score, order: .reverse)])
                    
                    highestScore = currentGameScores?.first
                    
                    if highestScore?.id == thisScore?.id {
                        isNewHiScore = true
                        hiScoreNoticeShouldFlash = true
                    }
                }
            }
            .onDisappear {
                gameController.stopSongFromCurrentAnswer()
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        SPFinalResults(onEndGame: {})
            .environment(SinglePlayerGameController())
            .modelContainer(for: [UCCategory.self, UCHiScoreEntry.self])
            .onAppear {
                let fontRegular = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 20)
                let fontLarge = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 36)
                UINavigationBar.appearance().titleTextAttributes = [.font: fontRegular!]
                UINavigationBar.appearance().largeTitleTextAttributes = [.font: fontLarge!]
            }
            .fontDesign(.monospaced)
    }
    
}
