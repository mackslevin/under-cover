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
    @Environment(\.modelContext) var modelContext
    
    @AppStorage(StorageKeys.secondsPerRound.rawValue) var secondsPerRound: Int = Utility.defaultSecondsPerRound
    @AppStorage(StorageKeys.guessLabelDisplayMode.rawValue) var guessMode: GuessLabelDisplayMode = .both
    @AppStorage(StorageKeys.shouldUseDesaturation.rawValue) var shouldUseDesaturation = false
    @AppStorage(StorageKeys.shouldUseMusic.rawValue) var shouldUseMusic = true
    
    @Query var albums: [UCAlbum]
    
    @State private var isShowingWelcome = false
    @State private var isShowingPhotoCredits = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General Configuration") {
                    Stepper("\(secondsPerRound) seconds per round", value: $secondsPerRound, in: 3...30)
                    
                    Picker("Guess Labels", selection: $guessMode) {
                        Text("Title Only").tag(GuessLabelDisplayMode.titleOnly)
                        Text("Artist Only").tag(GuessLabelDisplayMode.artistOnly)
                        Text("Both").tag(GuessLabelDisplayMode.both)
                    }
                    
                    Toggle("Black & White Mode", isOn: $shouldUseDesaturation)
                }
                
                Section("Music") {
                    Toggle("Play Music", isOn: $shouldUseMusic)
                        .padding(.bottom, 0)
                    
                    Group {
                        Text("When enabled, music from a given album will play while you're trying to guess it, if you have a currently active Apple Music Subscription.")
                            .italic()
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text("Subscriptions status:")
                            Text(appleMusicController.musicSubscription?.canPlayCatalogContent == true ? "Active" : "Not Found")
                                .bold()
                                .foregroundStyle(appleMusicController.musicSubscription?.canPlayCatalogContent == true ? .blue : .red)
                        }
                        
                    }
                    .listRowSeparator(.hidden)
                    
                    .font(.caption)
                }
                
                
                Section("Info") {
                    NavigationLink {
                        WelcomeView()
                            .navigationBarTitleDisplayMode(.inline) // To avoid empty space at top
                    } label: {
                        Label("Game Overview", systemImage: "info.circle")
                    }
                    .foregroundStyle(.primary)

                    NavigationLink {
                        PhotoCredits()
                    } label: {
                        Label("Photo Credits", systemImage: "camera")
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark", action: { dismiss() })
                }
            }
            .sheet(isPresented: $isShowingWelcome, content: {
                WelcomeView()
            })
            .sheet(isPresented: $isShowingPhotoCredits, content: {
                PhotoCredits()
            })
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppleMusicController())
        .fontDesign(.monospaced)
}
