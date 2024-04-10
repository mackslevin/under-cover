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
    
    @FocusState var isFocused
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    TextField("Enter text...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                    VStack {
                        ForEach(searchResults) { pl in
                            Button {
                                withAnimation {
                                    searchResults = []
                                    selectedPlaylist = pl
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(pl.name)
                                    }
                                    Spacer()
                                }
                            }
                            
                        }
                    }
                    
                    if let selectedPlaylist {
                        VStack {
                            AsyncImage(url: selectedPlaylist.artwork?.url(width: Utility.defaultArtworkSize, height: Utility.defaultArtworkSize)) { image in
                                image.resizable().scaledToFill()
                                    .frame(maxWidth: CGFloat(Utility.defaultArtworkSize))
                            } placeholder: {
                                Rectangle()
                                    .frame(maxWidth: CGFloat(Utility.defaultArtworkSize), maxHeight: CGFloat(Utility.defaultArtworkSize))
                            }
                            
                            Text(selectedPlaylist.name).font(.largeTitle)
                            
                            if let tracks = selectedPlaylist.tracks {
                                VStack(alignment: .leading) {
                                    ForEach(tracks) { track in
                                        
                                        
                                        VStack(alignment: .leading) {
                                            Text(track.title).fontWeight(.semibold)
                                            Text(track.artistName).foregroundStyle(.secondary)
                                        }
                                        
                                        .padding(.bottom, 8)
                                        .font(.caption)
                                        
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.vertical)
                        
                        
                        Button("Convert to Category", systemImage: "sparkles") {
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
                                        } else {
                                            print("^^ no album")
                                        }
                                        
                                    }
                                } else { print("^^ The playlist has no tracks") }
                                
                                if albums.count >= Utility.minimumAlbumsForCategory {
                                    newCategory.albums = albums
                                    modelContext.insert(newCategory)
                                    dismiss()
                                } else {
                                    isShowingPlaylistImportError = true
                                }
                            }
                        }
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
                
            }
        }
    }
    
    func search() {
        searchResults = []
        Task {
            let req = MusicCatalogSearchRequest(term: searchText, types: [Playlist.self])
            if let res = try? await req.response() {
                for pl in res.playlists {
                    withAnimation {
                        searchResults.append(pl)
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
