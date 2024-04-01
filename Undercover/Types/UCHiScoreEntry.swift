import Foundation
import SwiftData

@Model
class UCHiScoreEntry: Identifiable {
    let id = UUID()
    let categoryID: UUID? = nil
    let score: Int = 0
    let rounds: Int = 0
    let secondsPerRound: Int = 0
    let numberOfOptions: Int = 0
    let date = Date()
    
    init(categoryID: UUID, score: Int, rounds: Int, secondsPerRound: Int, numberOfOptions: Int) {
        self.categoryID = categoryID
        self.score = score
        self.rounds = rounds
        self.secondsPerRound = secondsPerRound
        self.numberOfOptions = numberOfOptions
    }
}
