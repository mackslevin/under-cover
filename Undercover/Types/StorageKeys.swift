//
//  StorageKeys.swift
//  Undercover
//
//  Created by Mack Slevin on 4/25/24.
//

import Foundation

enum StorageKeys: String {
    // The keys for values stored in @AppStorage/User Defaults
    case isFirstRun = "isFirstRun"
    case secondsPerRound = "secondsPerRound"
    case guessLabelDisplayMode = "guessLabelDisplayMode"
    case shouldUseDesaturation = "shouldUseDesaturation"
    case shouldUseMusic = "shouldUseMusic"
    case singlePlayerRounds = "singlePlayerRounds"
}
