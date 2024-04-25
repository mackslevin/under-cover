//
//  AppleMusicControllerError.swift
//  Undercover
//
//  Created by Mack Slevin on 4/23/24.
//

import Foundation

enum AppleMusicControllerError: LocalizedError, Equatable {
  case missingPermissions(message: String)
  case subscriptionRequired(message: String)
  case unknownError(message: String)
    
    var errorDescription: String? {
        switch self {
            case .missingPermissions(let message):
                message
            case .subscriptionRequired(let message):
                message
            case .unknownError(let message):
                message
        }
    }
    
    var failureReason: String? {
        switch self {
            case .missingPermissions(_):
                "Permission not granted."
            case .subscriptionRequired(_):
                "User is not logged in to Apple Music with an active account."
            case .unknownError(_):
                "Unknown"
        }
    }
}
