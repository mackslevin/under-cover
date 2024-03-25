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
    
    init(fromPlaylist playlist: Playlist) {
        // The expects the Playlist to be already populated with Tracks
        var albums: [Album]? = nil
        let tracks = playlist.tracks ?? []
        
        for track in tracks {
            if let album = track.albums?.first as? Album {
                // Make sure we haven't already added this album
                if let alreadyAdded = albums?.contains(where: {$0.id == album.id}), !alreadyAdded {
                    albums?.append(album)
                }
            } else {
                print("^^ Track but no album")
            }
        }
        
        self.name = playlist.name
        if let albums {
            self.albums = albums.map({ UCAlbum(fromAlbum: $0) })
        }
    }
    
//    init(fromSongs songs: [Song], withName name: String) {
//        self.name = name
//        
//        let albums: [UCAlbum]? = nil
//        for song in songs {
//            
//        }
//    }
}
