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
    @State private var playlists: [Playlist] = []
    @Query var categories: [UCCategory]
    @Environment(\.modelContext) var modelContext
    
    @State private var isShowingPlaylistImportError = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(playlists) { playlist in
                    HStack {
//                        AsyncImage(url: playlist.artwork?.url(width: 60, height: 60)) { image in
//                            image.resizable().scaledToFill()
//                                .frame(width: 40, height : 40)
//                        } placeholder: {
//                            ZStack {
//                                Rectangle().foregroundStyle(.gray.gradient)
//                                Image(systemName: "questionmark.square.dashed")
//                            }
//                            .frame(width: 40, height : 40)
//                        }
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        
                        VStack(alignment: .leading) {
                            Text(playlist.name)
                                .fontWeight(.semibold)
                            Text(playlist.curator?.name ?? "")
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Convert to Category") {
                            Task {
                                print("^^ tap")
                                await importPlaylist(playlist)
                            }
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
            }
            .navigationTitle("Playlists")
            .onAppear {
                let req = MusicLibraryRequest<Playlist>()
                Task {
                    if let res = try? await req.response() {
                        for item in res.items {
                            playlists.append(item)
                        }
                    }
                }
            }
            .alert("Error importing playlist", isPresented: $isShowingPlaylistImportError, actions: {Button("OK"){}})
        }
    }
    
    func importPlaylist(_ playlist: Playlist) async {
        var populatedPlaylist: Playlist? = nil
        if playlist.tracks == nil {
            print("^^ Populating playlist tracks")
            populatedPlaylist = try? await playlist.with([.tracks])
        } else {
            populatedPlaylist = playlist
        }
        guard let tracks = populatedPlaylist?.tracks else { return }
        
        var albums: [UCAlbum] = []
        
        for track in tracks {
            switch track {
                case .song(let song):
                    guard let albumTitle = song.albumTitle, let artworkURL = song.artwork?.url(width: Utility.defaultArtworkSize, height: Utility.defaultArtworkSize) else {
                        break }
                    let album = UCAlbum(musicItemID: song.id.rawValue, artistName: song.artistName, albumTitle: albumTitle, url: artworkURL)
                    albums.append(album)
                default:
                    print("^^ Not a song")
            }
        }
        
        
        
        
        
        if albums.count < Utility.minimumAlbumsForCategory {
            print("^^ Not enough albums")
            isShowingPlaylistImportError = true
        } else {
            print("^^ albums")
            albums.forEach({print($0.albumTitle)})
            let newCategory = UCCategory(name: playlist.name, albums: nil)
            newCategory.albums = albums
            
            await MainActor.run {
                modelContext.insert(newCategory)
                dismiss()
            }
            
        }
    }
}

#Preview {
    ImportPlaylistView()
        .modelContainer(for: UCCategory.self)
}
