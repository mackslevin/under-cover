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
                            Text(selectedPlaylist.curator?.name ?? "N/A")
                            
                            if let tracks = selectedPlaylist.tracks {
                                ForEach(tracks) { track in
                                    Text(track.title)
                                }
                            }
                            
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Convert Playlist to Category")
                .alert("Error importing playlist", isPresented: $isShowingPlaylistImportError, actions: {Button("OK"){}})
                .onAppear {
                    isFocused = true
                }
                .onChange(of: searchText) { _, newValue in
                    search()
                }
                .onChange(of: selectedPlaylist) { _, newValue in
                    if let newValue {
                        Task {
                            if let popVal = try? await newValue.with([.curator, .tracks]) {
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
}
