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
final class UCAlbum: Identifiable, Decodable {
    private(set) var id = UUID()
    var musicItemID: String = ""
    var artistName: String = ""
    var albumTitle: String = ""
    var coverImageURL: URL? = nil
    var category: UCCategory? = nil
    
    var isFavorited = false
    
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
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case musicItemID = "music_item_id"
        case artistName = "artist_name"
        case albumTitle = "album_title"
        case coverImageURL = "cover_image_url"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.musicItemID = try container.decode(String.self, forKey: .musicItemID)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        let coverURLString = try container.decode(String.self, forKey: .coverImageURL)
        self.coverImageURL = URL(string: coverURLString)
        self.category = nil
    }
}


