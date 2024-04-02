//
//  RoundResultBox.swift
//  Undercover
//
//  Created by Mack Slevin on 4/1/24.
//

import SwiftUI

struct RoundResultBox: View {
    @Environment(SinglePlayerGameController.self) var gameController
    @AppStorage("secondsPerRound") var secondsPerRound: Int = 30
    
    @State private var timeUsed = 0
    
    enum ResultState {
        case win, lose, timeOut
    }
    
    @State private var state: ResultState = .win
    @State private var symbolName = "hands.clap.fill"
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                HStack {
                    Image(systemName: symbolName)
                        .resizable().scaledToFit().frame(height: 36)
                    Text(state == .win ? "Correct!" : state == .timeOut ? "Time's Up!" : "Wrong!")
                        .fontDesign(.default) // Needed so it doesn't get overriden with monospace
                        .font(Font.custom(Font.customFontName, size: 32))
                        
                    Image(systemName: symbolName)
                        .resizable().scaledToFit().frame(height: 36)
                }
                .frame(maxWidth: .infinity)
            }
            
            if state != .timeOut {
                Text("Answered in \(timeUsed) seconds")
            }
            
            Text("Points total: \(gameController.points)")
                .fontWeight(.semibold)
        }
        .foregroundStyle(state == .win ? Color.accentColor : Color.red)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(state == .win ? Color.accentColor : Color.red)
                .opacity(0.1)
        }
        .onAppear {
            // Determine whether this was a winning or losing round
            if let rightAnswer = gameController.currentAnswer {
                let guess = gameController.currentGuess
                if guess == nil {
                    state = .timeOut
                } else if guess?.musicItemID == rightAnswer.musicItemID {
                    state = .win
                } else {
                    state = .lose
                }
            }
            
            // Determine the amount of time used up during the round
            timeUsed = secondsPerRound - (gameController.currentRoundSecondsRemaining ?? 0)
            
            // Determine which SF symbol to use
            switch state {
                case .lose:
                    symbolName = "square.slash"
                case .timeOut:
                    symbolName = "alarm.waves.left.and.right.fill"
                default:
                    symbolName = "hands.clap.fill"
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        RoundResultBox()
        Spacer()
    }
    .environment(SinglePlayerGameController())
//    .fontDesign(.monospaced)
}
