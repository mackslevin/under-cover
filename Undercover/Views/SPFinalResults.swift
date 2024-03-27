//
//  SPFinalResults.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import SwiftUI

struct SPFinalResults: View {
    @Environment(SinglePlayerGameController.self) var gameController
    
    let onEndGame: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.black)
            
            Text("Final score: \(gameController.points)")
                .font(.title)
            
            Button("Done") {
                onEndGame()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    SPFinalResults(onEndGame: {})
}
