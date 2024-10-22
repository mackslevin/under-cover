//
//  GetAlbumDataView.swift
//  Undercover
//
//  Created by Mack Slevin on 10/21/24.
//

import SwiftUI
import MusicKit

struct GetAlbumDataView: View {
    
    @State private var searchText: String = ""
    @State private var results: [Album] = []
    @State private var selectedAlbum: Album? = nil
    @State private var json = ""
    
    var body: some View {
        
        ScrollView {
            VStack {
                HStack {
                    TextField("Search...", text: $searchText)
                    Button("Search", systemImage: "magnifyingglass") {
                        Task {
                            await search()
                        }
                    }
                    .labelStyle(.iconOnly)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(results.prefix(5)) { album in
                        searchResultView(album: album)
                            .onTapGesture {
                                selectAlbum(album)
                            }
                    }
                }
                
                
                if selectedAlbum != nil {
                    Text(json)
                        .padding(.vertical)
                    Button("Copy", systemImage: "document.on.document") {
                        UIPasteboard.general.string = json
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .onChange(of: searchText) { oldValue, newValue in
                if newValue == "" {
                    results = []
                } else {
                    Task {
                        await search()
                    }
                }
            }
            .onChange(of: selectedAlbum) { oldValue, newValue in
                if let newValue {
                    json = """
                    {
                        "music_item_id":"\(newValue.id.rawValue)",
                        "artist_name":"\(newValue.artistName)",
                        "album_title":"\(newValue.title)",
                        "cover_image_url":"\(newValue.artwork?.url(width: Utility.defaultArtworkSize, height: Utility.defaultArtworkSize)?.absoluteString ?? "")"
                    }
                    """
                } else {
                    json = ""
                }
            }
        }
        
    }
    
    @MainActor
    func search() async {
        print("^^ Searching...")
        selectedAlbum = nil
        results = []
        
        do {
            let albums = try await AppleMusicController().searchCatalog(searchTerm: searchText, types: [Album.self]) as? [Album] ?? []
            
            results = albums
        } catch {
            print("^^ \(error.localizedDescription)")
        }
    }
    
    func selectAlbum(_ album: Album) {
        searchText = ""
        selectedAlbum = album
    }
    
    func searchResultView(album: Album) -> some View {
        HStack {
            AsyncImage(url: album.artwork?.url(width: 50, height: 50)) { image in
                image.resizable().scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
            } placeholder: {
                ZStack {
                    Rectangle().foregroundStyle(.secondary).frame(width: 40, height: 40)
                    ProgressView()
                }
            }

            VStack {
                Text(album.title)
                Text(album.artistName)
            }
            .font(.caption)
        }
    }
}

#Preview {
    GetAlbumDataView()
}
