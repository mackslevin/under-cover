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
    @State private var isNewHiScore = false
    @State private var highestScore: UCHiScoreEntry?
    @State private var currentGameScores: [UCHiScoreEntry]? = []
    
    @AppStorage("secondsPerRound") var secondsPerRound: Int = 30
    
    let onEndGame: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let thisScore {
                if isNewHiScore {
                    Text("New Hi Score: \(thisScore.score)!")
                        .font(.title2).foregroundStyle(.yellow).bold()
                } else {
                    Text("Final score: \(thisScore.score)")
                        .font(.title2).fontWeight(.bold)
                }
            }
            
            if let currentGameScores {
                VStack(alignment: .leading) {
                    
                        ForEach(currentGameScores.sorted(by: {$0.score > $1.score}).prefix(5)) { hiScore in
                            Text("#\((currentGameScores.sorted(by: {$0.score > $1.score}).firstIndex(of: hiScore) ?? 0) + 1): \(hiScore.score) - \(hiScore.date.formatted())")
                                .foregroundStyle(hiScore.id == thisScore?.id ? Color.yellow : Color.primary)
                                .fontWeight(hiScore.id == thisScore?.id ? .semibold : .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    
                }
                .padding()
                .background {
                    Rectangle()
                        .foregroundStyle(Color.accentColor)
                        .opacity(0.1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
            
            Button("Done") {
                onEndGame()
            }
            .buttonStyle(PillButtonStyle())
            
            
            Spacer()
        }
        .navigationTitle("Game Over")
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
                }
            }
            
            print("^^ gc pasts \(gameController.pastAnswers)")
        }
        .onDisappear {
            gameController.stopSongFromCurrentAnswer()
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
