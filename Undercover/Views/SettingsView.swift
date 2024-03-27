//
//  SettingsView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/21/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(AppleMusicController.self) var appleMusicController
    @Environment(\.dismiss) var dismiss
    @State private var isShowingImportPlaylist = false
    @AppStorage("secondsPerRound") var secondsPerRound: Int = 30
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button("Prompt for music library authorization") {
                        Task {
                            await appleMusicController.checkAuth()
                        }
                    }
                    
                    Button("Check Apple Music subscription") {
                        Task {
                            await appleMusicController.getMusicSubscriptionUpdates()
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: ImportPlaylistView()) {
                        Text("Playlists")
                    }
                }
                
                Section {
                    Stepper("\(secondsPerRound) seconds per round", value: $secondsPerRound, in: 3...50)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark", action: { dismiss() })
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppleMusicController())
}
