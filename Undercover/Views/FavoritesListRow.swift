//
//  FavoritesListRow.swift
//  Undercover
//
//  Created by Mack Slevin on 4/18/24.
//

import SwiftUI

struct FavoritesListRow: View {
    let album: UCAlbum
    
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
                    print("open")
                }
                .labelStyle(.iconOnly)
                
                Spacer()
                
                Button("Play", systemImage: "play.fill") {
                    print("play")
                }
                .labelStyle(.iconOnly)
                
                Spacer()
                
                Button("Share", systemImage: "square.and.arrow.up.fill") {
                    print("share")
                }
                .labelStyle(.iconOnly)
                
            }
            .font(.largeTitle)
            .padding(.vertical, 6)
            
            
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
