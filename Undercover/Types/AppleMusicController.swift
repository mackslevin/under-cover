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
}
