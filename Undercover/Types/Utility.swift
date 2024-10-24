//
//  Utility.swift
//  Undercover
//
//  Created by Mack Slevin on 3/25/24.
//

import SwiftUI

struct Utility {
    static let defaultArtworkSize = 800
    static let minimumAlbumsForCategory = 12
    static let defaultSecondsPerRound = 10
    
    static var hiScoresExplainer: String {
        "Hi scores are grouped based not only on the category but configuration of the game. For example, if you play a category at 3 rounds, you will only see scores for other times that category was played at 3 rounds."
    }
    
    static let victoryImageNames = [
        "victory1",
        "victory2",
        "victory3",
        "victory4",
        "victory5"
    ]
    
    static let nonvictoryImageNames = [
        "nonvictory1",
        "nonvictory2",
        "nonvictory3",
        "nonvictory4",
        "nonvictory5"
    ]
    
    static var presetCategories: [UCCategory] {
        var categories: [UCCategory] = []
        let filenames = ["test-category"]
        
        for filename in filenames {
            let jsonFileURL = Bundle.main.url(forResource: filename, withExtension: "json")!
            if let data = try? Data(contentsOf: jsonFileURL), let category = try? JSONDecoder().decode(UCCategory.self, from: data) {
                categories.append(category)
            }
        }
        
        return categories
    }
        
    
    static var testCategory: UCCategory {
        let jsonFileURL = Bundle.main.url(forResource: "test-category", withExtension: "json")!
        let data = try! Data(contentsOf: jsonFileURL)
        return try! JSONDecoder().decode(UCCategory.self, from: data)
    }
}
