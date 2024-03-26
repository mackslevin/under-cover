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
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem {
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
