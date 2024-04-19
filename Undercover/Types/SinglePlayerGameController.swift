//
//  SinglePlayerGameController.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import Foundation
import Observation
import MusicKit

@Observable
class SinglePlayerGameController {
    var rounds: Int = 3
    var inProgress = false
    var category: UCCategory? = nil
    var currentRound = 0
    var numberOfOptions = 3
    
    private var player = SystemMusicPlayer.shared
    
    var pastAnswers: [UCAlbum] = [] // After a round, we'll put the album that would have been (or was) the correct guess, so that we can check this when making future rounds and not repeat albums. (And to recap at the end.)
    var currentAnswer: UCAlbum? = nil
    var currentDecoys: [UCAlbum] = [] // Decoys meaning albums presented in the multiple choice which would be wrong answers
    var currentGuess: UCAlbum? = nil
    var currentRoundSecondsRemaining: Int? = nil
    
    var points = 0
    
    // MARK: Game State
    func reset() {
        inProgress = false
        currentRound = 0
        category = nil
        pastAnswers = []
        currentGuess = nil
        currentAnswer = nil
        currentDecoys = []
        points = 0
        currentRoundSecondsRemaining = nil
    }
    
    func generateRound() {
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
                options.contains(where: {$0.musicItemID == randomAlbum.musicItemID})
                ||
                pastAnswers.contains(where: {$0.musicItemID == randomAlbum.musicItemID})
            {
                if let random = albums.randomElement() { randomAlbum = random }
            }
            
            options.append(randomAlbum)
        }
        
        currentAnswer = options.randomElement()
        currentDecoys = options
        currentDecoys.removeAll(where: {$0.musicItemID == currentAnswer?.musicItemID})
    }
    
    func handleRoundEnd(withGuess guess: UCAlbum?, secondsRemaining: Int = 0) {
        if let currentAnswer {
            pastAnswers.append(currentAnswer)
        }
        
        guard let guess else {
            // Time probably ran out
            currentGuess = nil
            return
        }
        
        if guess.musicItemID == currentAnswer?.musicItemID {
            var newPoints = 100
            let secondsPerRound = UserDefaults.standard.integer(forKey: "secondsPerRound")
            let secondsUsed = secondsPerRound - secondsRemaining
            let pointsToDeduct = (Double(secondsUsed) / Double(secondsPerRound)) * 100
            newPoints -= Int(floor(pointsToDeduct))
            points += newPoints
        }
        
        currentGuess = guess
    }
    
    
    // MARK: Music
    
    func playSongFromCurrentAnswer() async throws {
        guard let currentAnswer else { print("^^ No current answer"); return }
        let musicItemID = currentAnswer.musicItemID
        var req = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: MusicItemID(musicItemID))
        req.limit = 1
        req.properties = [.tracks]
        let res = try await req.response()
        if let album = res.items.first {
            if let randomTrack = album.tracks?.randomElement() {
                player.queue = [randomTrack]
                try await player.play()
            }
        }
    }
    
    func stopSongFromCurrentAnswer() {
        player.stop()
    }
    
    // MARK: Hi Scores
    func hiScoresForCurrentGame(fromScores hiScores: [UCHiScoreEntry]) -> [UCHiScoreEntry]? {
        let categoryScores = hiScores.filter({
            $0.categoryID == category?.id &&
            $0.rounds == rounds &&
            $0.secondsPerRound == UserDefaults.standard.integer(forKey: "secondsPerRound") &&
            $0.numberOfOptions == numberOfOptions
        })
        
        if categoryScores.isEmpty {
            return nil
        } else { 
            return categoryScores.sorted(by: {$0.score > $1.score})
        }
    }
}
