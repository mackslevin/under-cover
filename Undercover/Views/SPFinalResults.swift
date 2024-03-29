//
//  SPFinalResults.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import SwiftUI
import SwiftData

struct SPFinalResults: View {
    @Environment(SinglePlayerGameController.self) var gameController
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\UCHiScoreEntry.date, order: .reverse)]) var hiScores: [UCHiScoreEntry]
    @State private var thisScore: UCHiScoreEntry?
    @State private var isNewHiScore = false
    @State private var highestScore: UCHiScoreEntry?
    
    @State private var currentGameScores: [UCHiScoreEntry]? = []
    
    @AppStorage("secondsPerRound") var secondsPerRound: Int = 30
    
    let onEndGame: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.black)
            
            if let thisScore {
                if isNewHiScore {
                    Text("New Hi Score: \(thisScore.score)!")
                        .font(.title).foregroundStyle(.yellow).bold()
                } else {
                    Text("Final score: \(thisScore.score)")
                        .font(.title)
                    
                    if let highestScore {
                        Text("Current Hi Score: \(highestScore.score) on \(highestScore.date.formatted())")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            if let currentGameScores {
                ForEach(currentGameScores.sorted(by: {$0.score > $1.score})) { hiScore in
                    Text("#\((currentGameScores.firstIndex(of: hiScore) ?? 0) + 1): \(hiScore.score) - \(hiScore.date.formatted())")
                        .foregroundStyle(hiScore.id == thisScore?.id ? Color.yellow : Color.primary)
                }
            }
            
            
            Button("Done") {
                onEndGame()
            }
            .buttonStyle(.borderedProminent)
        }
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
            
            
        }
        .onDisappear {
            gameController.stopSongFromCurrentAnswer()
        }
    }
}

#Preview {
    SPFinalResults(onEndGame: {})
}
