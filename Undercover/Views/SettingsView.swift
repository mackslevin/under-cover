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
    @AppStorage(StorageKeys.shouldUseDesaturation.rawValue) var shouldUseDesaturation = false
    @AppStorage(StorageKeys.shouldUseMusic.rawValue) var shouldUseMusic = true
    
    @Query var albums: [UCAlbum]
    
    @State private var isShowingWelcome = false
    @State private var isShowingPhotoCredits = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Game Configuration") {
                    Stepper("\(secondsPerRound) seconds per round", value: $secondsPerRound, in: 3...30)
                    
                    Picker("Guess Labels", selection: $guessMode) {
                        Text("Title Only").tag(GuessLabelDisplayMode.titleOnly)
                        Text("Artist Only").tag(GuessLabelDisplayMode.artistOnly)
                        Text("Both").tag(GuessLabelDisplayMode.both)
                    }
                    
                    Toggle("Black & White Mode", isOn: $shouldUseDesaturation)
                    
                    Toggle("Play Music", isOn: $shouldUseMusic)
                }
                
                Section("Info") {
                    Button("Overview") {
                        isShowingWelcome.toggle()
                    }
                    
//                    Button {
//                        isShowingPhotoCredits.toggle()
//                    } label: {
//                        Label("Photo Credits", systemImage: "photo")
//                            
//                    }
                    
                    NavigationLink {
                        PhotoCredits()
                    } label: {
                        Label("Photo Credits", systemImage: "photo")
                    }

                    
                }
                .foregroundStyle(.primary)
                
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
            .sheet(isPresented: $isShowingPhotoCredits, content: {
                PhotoCredits()
            })
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppleMusicController())
}
