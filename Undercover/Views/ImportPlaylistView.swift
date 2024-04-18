//
//  ImportPlaylistView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/21/24.
//

import SwiftUI
import MusicKit
import SwiftData

struct ImportPlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @Query var categories: [UCCategory]
    @Environment(\.modelContext) var modelContext
    @State private var isShowingPlaylistImportError = false
    
    @State private var searchText = ""
    @State private var searchResults: [Playlist] = []
    @State private var selectedPlaylist: Playlist? = nil
    @State private var isConverting = false
    
    @FocusState var isFocused
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    TextField("Enter text...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                        .padding(.bottom, 4) // Match default spacing of VStack below
                    
                    VStack {
                        ForEach(searchResults) { pl in
                            PlaylistSearchResultsRow(playlist: pl) {
                                withAnimation {
                                    searchResults = []
                                    selectedPlaylist = pl
                                }
                            }
                        }
                    }
                    
                    if let selectedPlaylist {
                        Group {
                            if isConverting {
                                VStack(spacing: 12) {
                                    ProgressView()
                                    Text("Converting...")
                                        .font(.title3)
                                }.padding(.vertical)
                            } else {
                                PlaylistInfoCard(playlist: selectedPlaylist) {
                                    withAnimation {
                                        isConverting = true
                                    }
                                    
                                    // Create new UCCategory and loop through the Playlist's tracks to grab the albums for the new category.
                                    let newCategory = UCCategory(name: selectedPlaylist.name)
                                    var albums: [UCAlbum] = []
                                    
                                    Task {
                                        if let tracks = selectedPlaylist.tracks {
                                            for track in tracks {
                                                var req = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: track.id)
                                                req.limit = 1
                                                req.properties = [.albums]
                                                
                                                let res = try await req.response()
                                                if let album = res.items.first?.albums?.first {
                                                    albums.append(UCAlbum(fromAlbum: album))
                                                }
                                            }
                                        } else {
                                            isConverting = false
                                            isShowingPlaylistImportError = true
                                        }
                                        
                                        if albums.count >= Utility.minimumAlbumsForCategory {
                                            newCategory.albums = albums
                                            modelContext.insert(newCategory)
                                            isConverting = false
                                            dismiss()
                                        } else {
                                            isConverting = false
                                            isShowingPlaylistImportError = true
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Search Playlists")
                .alert("Error importing playlist", isPresented: $isShowingPlaylistImportError, actions: {Button("OK"){}})
                .onAppear {
                    isFocused = true
                }
                .onChange(of: searchText) { _, newValue in
                    selectedPlaylist = nil
                    search()
                }
                .onChange(of: selectedPlaylist) { _, newValue in
                    if let newValue {
                        isFocused = false
                        Task {
                            if let popVal = try? await newValue.with([.tracks]) {
                                withAnimation {
                                    selectedPlaylist = popVal
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close", systemImage: "xmark") { dismiss() }
                    }
                }
                
            }
        }
    }
    
    func search() {
        searchResults = []
        Task {
            let req = MusicCatalogSearchRequest(term: searchText, types: [Playlist.self])
            
            if let res = try? await req.response() {
                for pl in res.playlists {
                    let populated = try await pl.with([.entries])
                    
                    withAnimation {
                        if selectedPlaylist == nil {
                            searchResults.append(populated)
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ImportPlaylistView()
        .modelContainer(for: UCCategory.self)
        .onAppear {
            let fontRegular = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 20)
            let fontLarge = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 36)
            UINavigationBar.appearance().titleTextAttributes = [.font: fontRegular!]
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: fontLarge!]
        }
}
