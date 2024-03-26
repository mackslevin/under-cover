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
    var currentRound = 1
    var numberOfOptions = 3
    
    var pastAnswers: [UCAlbum] = [] // After a round, we'll put the album that would have been (or was) the correct guess, so that we can check this when making future rounds and not repeat albums.
    var currentAnswer: UCAlbum? = nil
    var currentDecoys: [UCAlbum] = [] // Decoys meaning albums presented in the multiple choice which would be wrong answers
}
