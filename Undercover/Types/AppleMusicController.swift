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
    func checkAuth() async {
        // This should prompt the user for authorization if unauthorized
        
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            isAuthorized = true
        default:
            isAuthorized = false
        }
    }

    var musicSubscription: MusicSubscription?
    func getMusicSubscriptionUpdates() async {
        for await subscriptionType in MusicSubscription.subscriptionUpdates {
            await MainActor.run {
                musicSubscription = subscriptionType
                print("^^ sub type \(subscriptionType)")
            }
        }
    }
    
    func catalogAlbums(_ ucAlbums: [UCAlbum]) async throws -> [Album] {
        for ucAlbum in ucAlbums {
            do {
                var req = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: MusicItemID(ucAlbum.musicItemID))
                req.limit = 1
                req.properties = [.artists]
                let res = try await req.response()
                var albums: [Album] = []
                for album in res.items {
                    albums.append(album)
                }
                return albums
            } catch {
                print(error)
                throw error
            }
        }
        
        return []
    }
}
