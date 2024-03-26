//
//  SinglePlayerGameView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import SwiftUI

struct SinglePlayerGameView: View {
    @Environment(SinglePlayerGameController.self) var gameController
    @State private var gameState: GameState = .guessing
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SinglePlayerGameView()
}





