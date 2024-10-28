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
    
    var isPreset: Bool = false
    
    init(name: String, albums: [UCAlbum]? = nil, isPreset: Bool = false) {
        self.name = name
        self.albums = albums
        self.isPreset = isPreset
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
    
    private static var presetCategories: [UCCategory] {
        var categories: [UCCategory] = []
        let filenames = [
            "hyperpop",
            "test-category"
        ]
        
        for filename in filenames {
            let jsonFileURL = Bundle.main.url(forResource: filename, withExtension: "json")!
            if let data = try? Data(contentsOf: jsonFileURL), let category = try? JSONDecoder().decode(UCCategory.self, from: data) {
                category.isPreset = true
                categories.append(category)
            }
        }
        
        return categories
    }
    
    static func syncPresets(modelContext: ModelContext) {
        let request = FetchDescriptor<UCCategory>()
        
        do {
            let allCategories = try modelContext.fetch(request)
            
            // Add any new presets, make sure existing ones have up-to-date album entries
            for preset in presetCategories {
                if let alreadySavedPreset = allCategories.first(where: { $0.id == preset.id }) {
                    var shouldOverwriteAlbums = false
                    
                    if preset.albums?.count != alreadySavedPreset.albums?.count {
                        shouldOverwriteAlbums = true
                    } else {
                        for album in preset.albums ?? [] {
                            if alreadySavedPreset.albums?.first(where: { $0.id == album.id }) == nil {
                                shouldOverwriteAlbums = true
                            }
                        }
                    }
                    
                    if shouldOverwriteAlbums {
                        print("^^ Updating albums for \(preset.name)")
                        alreadySavedPreset.albums = preset.albums
                        try modelContext.save()
                    }
                } else {
                    modelContext.insert(preset)
                }
            }
            
            // Remove any lingering presets that are no longer included
            let savedPresets = allCategories.filter(\.isPreset)
            for savedPreset in savedPresets {
                if !presetCategories.contains(where: { $0.id == savedPreset.id }) {
                    modelContext.delete(savedPreset)
                }
            }
        } catch {
            print("^^ Error fetching categories: \(error)")
        }
    }
}
