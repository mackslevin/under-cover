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
        ScrollView {
            VStack(spacing: 20) {
                Text(gameController.currentAnswer?.musicItemID == gameController.currentGuess?.musicItemID ? "Correct!" : gameController.currentGuess == nil ? "Out of time!" : "Wrong!")
                    .font(.largeTitle).fontWeight(.black)
                    .foregroundStyle(gameController.currentAnswer?.musicItemID == gameController.currentGuess?.musicItemID ? .blue : gameController.currentGuess == nil ? .orange : .red)
                
                if let rightAnswer = gameController.currentAnswer {
                    VStack {
                        AsyncImage(url: rightAnswer.coverImageURL) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Rectangle()
                        }
                        .frame(maxWidth: 500, maxHeight: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding()
                        
                        .shadow(radius: 12)

                        VStack() {
                            Text(rightAnswer.albumTitle).italic().fontWeight(.semibold)
                            Text("by \(rightAnswer.artistName)")
                        }
                        .font(.title2)
                    }
                }
                
                Text("Points: \(gameController.points)")
                    .font(.title2).bold()
                
                Button("Next") {
                    onNext()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        
    }
}

#Preview {
    SPRoundResults(onNext: {})
}
