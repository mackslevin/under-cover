//
//  SinglePlayerGameView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import SwiftUI

struct SinglePlayerGameView: View {
    @Environment(SinglePlayerGameController.self) var gameController
    @Environment(\.dismiss) var dismiss
    @State private var gameState: GameState = .guessing
    
    var body: some View {
        NavigationStack {
            switch gameState {
                case .guessing:
                    SPGuessingView(onRoundEnd: {
                        gameState = .roundResults
                    })
                case .roundResults:
                    SPRoundResults(onNext: {
                        gameState = .guessing
                    })
                case .finalResults:
                    SPFinalResults(onEndGame: {
                        gameController.reset()
                        dismiss()
                    })
            }
        }
        .onChange(of: gameController.inProgress) { _, newValue in
            if newValue == false {
                gameState = .finalResults
            }
        }
    }
}

#Preview {
    SinglePlayerGameView()
}





