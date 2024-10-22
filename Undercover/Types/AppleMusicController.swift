//
//  AppleMusicAuthController.swift
//  Undercover
//
//  Created by Mack Slevin on 3/21/24.
//

import Foundation
import Observation
import MusicKit

@Observable
class AppleMusicController {
    var isAuthorized = false
    var error: AppleMusicControllerError? = nil
    
    func checkAuth() async {
        let status = await MusicAuthorization.request()

        switch status {
        case .authorized:
            isAuthorized = true
        default:
            isAuthorized = false
                error = AppleMusicControllerError.missingPermissions(message: "This app requires Apple Music access in order to gather music information and construct categories for you to play. Please allow this in Settings.")
        }
    }

    var musicSubscription: MusicSubscription?
    func getMusicSubscriptionUpdates() async {
        for await subscriptionType in MusicSubscription.subscriptionUpdates {
            await MainActor.run {
                musicSubscription = subscriptionType
                
                if !(musicSubscription?.canPlayCatalogContent == true) {
                    error = AppleMusicControllerError.subscriptionRequired(message: "No active Apple Music subscription found. Album covers will still show but this app will not be able to play music from the albums.")
                }
            }
        }
    }
    
    func catalogAlbum(_ ucAlbum: UCAlbum) async throws -> Album? {
        do {
            var req = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: MusicItemID(ucAlbum.musicItemID))
            req.limit = 1
            let res = try await req.response()
            return res.items.first
        } catch {
            throw error
        }
    }
    
    func searchCatalog(searchTerm: String, types: [MusicCatalogSearchable.Type]) async throws -> [MusicCatalogSearchable]? {
        let request = MusicCatalogSearchRequest(term: searchTerm, types: types)
        let response = try await request.response()
        
        var items: [MusicCatalogSearchable] = []
        for type in types {
            let eligibleResults = resultsOfType(type, fromResponse: response)
            items.append(contentsOf: eligibleResults)
        }
        
        if items.isEmpty {
            return nil
        } else {
            return items
        }
    }
    
    private func resultsOfType(_ type: MusicCatalogSearchable.Type, fromResponse response: MusicCatalogSearchResponse) -> [MusicCatalogSearchable] {
        
        if type == Album.self {
            
            return response.albums.map({$0})
        } else if type == Artist.self {
            return response.artists.map({$0})
        } else if type == Song.self {
            return response.songs.map({$0})
        } else if type == Playlist.self {
            return response.playlists.map({$0})
        }
        // I know we're not covering all cases 🤷‍♂️
        
        return []
    }
}
