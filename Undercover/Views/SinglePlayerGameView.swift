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
                        print("^^ state change")
                        gameState = .roundResults
                    })
                case .roundResults:
                    SPRoundResults(onNext: {
                        print("^^ state change")
                        gameState = .guessing
                    })
                case .finalResults:
                    SPFinalResults(onEndGame: {
                        print("^^ state change")
                        gameController.reset()
                        dismiss()
                    })
            }
        }
        .onChange(of: gameController.inProgress) { _, newValue in
            print("^^ new inProgress val \(newValue)")
            
            if newValue == false {
                gameState = .finalResults
            }
        }
    }
}

#Preview {
    SinglePlayerGameView()
}





