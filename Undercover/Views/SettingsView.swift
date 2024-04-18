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
    @AppStorage("secondsPerRound") var secondsPerRound: Int = 30
    @AppStorage("guessLabelDisplayMode") var guessMode: GuessLabelDisplayMode = .both
    @AppStorage("shouldUseDesaturation") var shouldUseDesaturation = true
    @AppStorage("shouldUseMusic") var shouldUseMusic = true
    
    @Query var albums: [UCAlbum]
    
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
                    Stepper("\(secondsPerRound) seconds per round", value: $secondsPerRound, in: 3...30)
                    
                    Picker("Guess Labels", selection: $guessMode) {
                        Text("Title Only").tag(GuessLabelDisplayMode.titleOnly)
                        Text("Artist Only").tag(GuessLabelDisplayMode.artistOnly)
                        Text("Both").tag(GuessLabelDisplayMode.both)
                    }
                    
                    Toggle("Black & White Mode", isOn: $shouldUseDesaturation)
                    
                    Toggle("Play Music", isOn: $shouldUseMusic)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark", action: { dismiss() })
                }
            }
            .onAppear {
                print("^^ total albums: \(albums.count)")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppleMusicController())
}
