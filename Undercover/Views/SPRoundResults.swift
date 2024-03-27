//
//  SPRoundResults.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import SwiftUI

struct SPRoundResults: View {
    @Environment(SinglePlayerGameController.self) var gameController
    
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(gameController.currentAnswer?.musicItemID == gameController.currentGuess?.musicItemID ? "Correct!" : gameController.currentGuess == nil ? "Out of time!" : "Wrong!")
                .font(.largeTitle)
            
            if let rightAnswer = gameController.currentAnswer {
                HStack {
                    AsyncImage(url: rightAnswer.coverImageURL) { image in
                        image.resizable().scaledToFit()
                            .frame(width: 100, height: 100)
                            
                    } placeholder: {
                        Color.gray
                            .frame(width: 100, height: 100)
                    }

                    VStack(alignment: .leading) {
                        Text(rightAnswer.albumTitle).italic()
                        Text(rightAnswer.artistName)
                    }
                    
                    
                }
            }
            
            Text("Points: \(gameController.points)")
            
            Button("Next") {
                onNext()
            }
        }
    }
}

#Preview {
    SPRoundResults(onNext: {})
}
