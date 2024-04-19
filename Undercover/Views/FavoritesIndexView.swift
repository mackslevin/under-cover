//
//  FavoritesIndexView.swift
//  Undercover
//
//  Created by Mack Slevin on 4/18/24.
//

import SwiftUI
import SwiftData

struct FavoritesIndexView: View {
    @Environment(\.dismiss) var dismiss
    @Query(filter: #Predicate<UCAlbum> { $0.isFavorited }) var favoritedAlbums: [UCAlbum]
    
    var body: some View {
        NavigationStack {
            List(favoritedAlbums) { album in
                FavoritesListRow(album: album)
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listRowInsets(EdgeInsets())
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
            
        }
    }
}

#Preview {
    FavoritesIndexView()
}
