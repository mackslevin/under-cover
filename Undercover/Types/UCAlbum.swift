//
//  UCAlbum.swift
//  Undercover
//
//  Created by Mack Slevin on 3/21/24.
//

import Foundation
import SwiftData
import MusicKit

@Model
class UCAlbum: Identifiable {
    let id = UUID()
    let musicItemID: String = ""
    let artistName: String = ""
    let albumTitle: String = ""
    var coverImageURL: URL? = nil
    var category: UCCategory? = nil
    
    init(musicItemID: String, artistName: String, albumTitle: String, url: URL?) {
        self.musicItemID = musicItemID
        self.artistName = artistName
        self.albumTitle = albumTitle
        self.coverImageURL = url
    }
    
    init(fromAlbum album: Album) {
        self.musicItemID = album.id.rawValue
        self.artistName = album.artistName
        self.albumTitle = album.title
        self.coverImageURL = album.artwork?.url(width: Utility.defaultArtworkSize, height: Utility.defaultArtworkSize)
    }
}
