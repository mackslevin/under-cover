//
//  SinglePlayerGameController.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import Foundation
import Observation

@Observable
class SinglePlayerGameController {
    var rounds: Int = 3
    var inProgress = false
    var category: UCCategory? = nil
    var currentRound = 0
    var numberOfOptions = 3
    
    var pastAnswers: [UCAlbum] = [] // After a round, we'll put the album that would have been (or was) the correct guess, so that we can check this when making future rounds and not repeat albums.
    var currentAnswer: UCAlbum? = nil
    var currentDecoys: [UCAlbum] = [] // Decoys meaning albums presented in the multiple choice which would be wrong answers
    var currentGuess: UCAlbum? = nil
    
    var points = 0
    
    
    func reset() {
        inProgress = false
        currentRound = 0
        category = nil
        pastAnswers = []
        currentGuess = nil
        currentAnswer = nil
        currentDecoys = []
        points = 0
    }
    
    func generateRound() {
        print("^^ generating round. current: \(currentRound). category: \(category?.name ?? "none")")
        
        currentRound += 1
        guard currentRound <= rounds, let albums = category?.albums else {
            inProgress = false
            return
        }
        if currentRound == 1 {
            inProgress = true
            pastAnswers = []
        }
        
        currentAnswer = nil
        currentDecoys = []
        currentGuess = nil
        
        var options: [UCAlbum] = []
        for _ in 1...numberOfOptions {
            guard var randomAlbum = albums.randomElement() else { return }
            
            while
                options.contains(where: {$0.musicItemID == randomAlbum.musicItemID}),
                pastAnswers.contains(where: {$0.musicItemID == randomAlbum.musicItemID})
            {
                if let random = albums.randomElement() { randomAlbum = random }
                
            }
            
            options.append(randomAlbum)
        }
        
        currentAnswer = options.randomElement()
        currentDecoys = options
        currentDecoys.removeAll(where: {$0.musicItemID == currentAnswer?.musicItemID})
        
        print("^^ current answer: \(currentAnswer!.albumTitle)")
        print("^^ decoys: ")
        for d in currentDecoys {
            print("^^^ \(d.albumTitle)")
        }
    }
    
    func handleRoundEnd(withGuess guess: UCAlbum?, secondsRemaining: Int = 0) {
        if let currentAnswer { pastAnswers.append(currentAnswer) }
        
        guard let guess else {
            // Time probably ran out
            currentGuess = nil
            return
        }
        
        if guess.musicItemID == currentAnswer?.musicItemID {
            points += secondsRemaining
        }
        
        currentGuess = guess
    }
}
