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
    @Relationship(inverse: \UCAlbum.category) var albums: [UCAlbum]?
    
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
}
