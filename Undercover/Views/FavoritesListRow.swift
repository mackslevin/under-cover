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
    
    let dummyURL = URL(string: "https://amvolume.com")!
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                AsyncImage(url: album.coverImageURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
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
            .frame(maxHeight: 120)
            
            HStack {
                Button("Open in Apple Music", systemImage: "arrow.up.right.square.fill") {
                    UIApplication.shared.open(catalogAlbum?.url ?? dummyURL)
                }
                .disabled(catalogAlbum?.url == nil)
                
                Spacer()
                
                Button("Play", systemImage: "play.fill") {
                    print("play")
                }
                
                Spacer()
                
                ShareLink(item: catalogAlbum?.url ?? dummyURL)
                    .disabled(catalogAlbum?.url == nil)
            }
            .font(.largeTitle)
            .padding(.vertical, 6)
            .labelStyle(.iconOnly)
            
            
        }
        .listRowSeparator(.hidden)
        .padding(.bottom, 10)
        .overlay {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 1)
                    .opacity(0.15)
                Rectangle()
                    .frame(height: 2)
                    .opacity(0.07)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            Task {
                catalogAlbum = try? await appleMusicController.catalogAlbum(album)
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
