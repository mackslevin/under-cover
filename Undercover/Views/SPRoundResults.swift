//
//  SPRoundResults.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import SwiftUI
import SwiftData

struct SPRoundResults: View {
    @Environment(SinglePlayerGameController.self) var gameController
    
    let onNext: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let rightAnswer = gameController.currentAnswer {
                    VStack {
                        AsyncImage(url: rightAnswer.coverImageURL) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Rectangle()
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(maxWidth: 500, maxHeight: 500)
                        .shadow(radius: 12)
                        .padding()

                        VStack() {
                            Text(rightAnswer.albumTitle).italic().fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                            Text("by \(rightAnswer.artistName)")
                                .multilineTextAlignment(.center)
                        }
                        .font(.title2)
                        .padding(.bottom)
                        
                        Text(gameController.currentAnswer?.musicItemID == gameController.currentGuess?.musicItemID ? "Correct!" : gameController.currentGuess == nil ? "Out of time!" : "Wrong!")
                            .font(.largeTitle).fontWeight(.black)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background {
                                Capsule()
                                    .foregroundStyle(gameController.currentAnswer?.musicItemID == gameController.currentGuess?.musicItemID ? .blue : gameController.currentGuess == nil ? .orange : .red)
                            }
                    }
                }
                
                Text("Points: \(gameController.points)")
                    .font(.title2).bold()
                
                Button("\(gameController.currentRound == gameController.rounds ? "Done" : "Next")") {
                    onNext()
                }
                .buttonStyle(.plain)
                .bold()
                .font(.title2)
                .foregroundStyle(.tint)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding([.horizontal, .bottom])
        }
        
    }
}

#Preview {
    SPRoundResults(onNext: {})
}
