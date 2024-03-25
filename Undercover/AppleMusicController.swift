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
}
