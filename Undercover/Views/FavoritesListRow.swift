//
//  FavoritesListRow.swift
//  Undercover
//
//  Created by Mack Slevin on 4/18/24.
//

import SwiftUI
import MusicKit

struct FavoritesListRow: View {
    @Environment(AppleMusicController.self) var appleMusicController
    @State private var catalogAlbum: Album? = nil
    
    let album: UCAlbum
    
    let musicPlayer = SystemMusicPlayer.shared
    let dummyURL = URL(string: "https://amvolume.com")!
    
    let maxArtworkSize: CGFloat = 120
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                AsyncImage(url: album.coverImageURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: maxArtworkSize, maxHeight: maxArtworkSize)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 1, x: 1, y: 2)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(album.albumTitle)
                            .italic()
                        Text("by \(album.artistName)")
                        
                        Spacer()
                        
                        if let category = album.category {
                            Text("From the category \"\(category.name)\"")
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                }
            }
            .frame(maxHeight: maxArtworkSize)
            
            HStack {
                Button("Open in Apple Music", systemImage: "arrow.up.right.square.fill") {
                    UIApplication.shared.open(catalogAlbum?.url ?? dummyURL)
                }
                .disabled(catalogAlbum?.url == nil)
                
                Spacer()
                
                Button("Play", systemImage: "play.fill") {
                    print("play")
                    if let catalogAlbum, let track1 = catalogAlbum.tracks?.first {
                        musicPlayer.queue = .init(album: catalogAlbum, startingAt: track1)
                        
                        Task {
                            try? await musicPlayer.prepareToPlay()
                            try? await musicPlayer.play()
                        }
                    }
                }
                .disabled(catalogAlbum == nil)
                
                Spacer()

                ShareLink(item: catalogAlbum?.url ?? dummyURL) {
                    Label("Share", systemImage: "square.and.arrow.up.fill")
                }
            }
            .font(.largeTitle)
            .padding(.vertical, 6)
            .labelStyle(.iconOnly)
        }
        .listRowSeparator(.hidden)
        .listRowSpacing(0)
        .onAppear {
            Task {
                var req = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: MusicItemID(album.musicItemID))
                req.limit = 1
                req.properties = [.tracks]
                if let response = try? await req.response(), let fetchedAlbum = response.items.first {
                    catalogAlbum = fetchedAlbum
                }
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        List {
//            FavoritesListRow()
//            FavoritesListRow()
//            FavoritesListRow()
//        }
//        .listRowSpacing(20)
//        .listStyle(.plain)
//        .listRowInsets(EdgeInsets())
//        .navigationTitle("Favorites")
//        .toolbar {
//            ToolbarItem(placement: .cancellationAction) {
//                Button("Close", systemImage: "xmark") {
//                }
//            }
//        }
//        .fontDesign(.monospaced)
//    }
//}
