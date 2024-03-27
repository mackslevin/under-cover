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
        VStack {
            Text("Game Over")
                .font(.largeTitle)
            
            Text("Final score: \(gameController.points)")
            
            Button("Done") {
                onEndGame()
            }
        }
    }
}

#Preview {
    SPFinalResults(onEndGame: {})
}
