import Foundation
import SwiftData

@Model
class UCHiScoreEntry: Identifiable {
    private(set) var id = UUID()
    private(set) var categoryID: UUID? = nil
    private(set) var score: Int = 0
    private(set) var rounds: Int = 0
    private(set) var secondsPerRound: Int = Utility.defaultSecondsPerRound
    private(set) var numberOfOptions: Int = 0
    private(set) var date = Date()
    
    init(categoryID: UUID, score: Int, rounds: Int, secondsPerRound: Int, numberOfOptions: Int) {
        self.categoryID = categoryID
        self.score = score
        self.rounds = rounds
        self.secondsPerRound = secondsPerRound
        self.numberOfOptions = numberOfOptions
    }
}
