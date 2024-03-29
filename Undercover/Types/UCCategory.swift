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
class UCCategory: Identifiable {
    let id = UUID()
    var name: String = ""
    @Relationship(inverse: \UCAlbum.category) var albums: [UCAlbum]?
    
    init(name: String, albums: [UCAlbum]? = nil) {
        self.name = name
        self.albums = albums
    }
}
