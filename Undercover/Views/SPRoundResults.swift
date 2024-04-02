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
                    
                    AsyncImage(url: rightAnswer.coverImageURL) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Rectangle()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(maxWidth: 500, maxHeight: 500)
                    .shadow(radius: 12)
                    
                    RoundResultBox()
                    
                    Button("\(gameController.currentRound == gameController.rounds ? "Done" : "Next")") {
                        onNext()
                    }
                    .buttonStyle(PillButtonStyle())
                    .bold()
                    .font(.title2)
                    
                    if let currentAnswer = gameController.currentAnswer {
                        BasicAlbumCard(ucAlbum: currentAnswer)
                    }
                    
                }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding([.horizontal, .bottom])
            .onAppear {
                print("^^ time remaining \(gameController.currentRoundSecondsRemaining)")
            }
        }
        
    }
}

//#Preview {
//    SPRoundResults(onNext: {})
//}
