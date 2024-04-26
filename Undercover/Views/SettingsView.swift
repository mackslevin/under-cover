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
    @AppStorage(StorageKeys.secondsPerRound.rawValue) var secondsPerRound: Int = Utility.defaultSecondsPerRound
    @AppStorage(StorageKeys.guessLabelDisplayMode.rawValue) var guessMode: GuessLabelDisplayMode = .both
    @AppStorage(StorageKeys.shouldUseDesaturation.rawValue) var shouldUseDesaturation = true
    @AppStorage(StorageKeys.shouldUseMusic.rawValue) var shouldUseMusic = true
    
    @Query var albums: [UCAlbum]
    
    @State private var isShowingWelcome = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button("Refresh music library authorization") {
                        Task {
                            await appleMusicController.checkAuth()
                        }
                    }
                    
                    Button("Refresh Apple Music subscription status") {
                        Task {
                            await appleMusicController.getMusicSubscriptionUpdates()
                        }
                    }
                }
                .bold()
                
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
                
                Section {
                    Button("View welcome screens") {
                        isShowingWelcome.toggle()
                    }
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
            .sheet(isPresented: $isShowingWelcome, content: {
                WelcomeView()
            })
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppleMusicController())
}
