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
        VStack(alignment: .leading, spacing: 40) {
            VStack {
                Text("GAME OVER")
                    .italic()
                Text("483pts")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.largeTitle)
            .fontWeight(.black)
            
            Button("Done") {
                onEndGame()
            }
            .bold()
            .buttonStyle(PillButtonStyle())
            
            Spacer()
        }
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
