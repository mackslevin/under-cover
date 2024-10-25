//
//  UCCategory.swift
//  Undercover
//
//  Created by Mack Slevin on 3/21/24.
//

import Foundation
import MusicKit
import SwiftData

@Model
class UCCategory: Identifiable, Decodable {
    private(set) var id = UUID()
    var name: String = ""
    @Relationship(deleteRule: .cascade, inverse: \UCAlbum.category) var albums: [UCAlbum]?
    
    init(name: String, albums: [UCAlbum]? = nil) {
        self.name = name
        self.albums = albums
    }
    
    enum CodingKeys: CodingKey {
        case id, name, albums
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        albums = try container.decodeIfPresent([UCAlbum].self, forKey: .albums)
    }
    
    static var testCategory: UCCategory {
        let jsonFileURL = Bundle.main.url(forResource: "test-category", withExtension: "json")!
        let data = try! Data(contentsOf: jsonFileURL)
        return try! JSONDecoder().decode(UCCategory.self, from: data)
    }
    
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
}
