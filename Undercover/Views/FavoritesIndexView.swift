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
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<UCAlbum> { $0.isFavorited }) var favoritedAlbums: [UCAlbum]
    
    var body: some View {
        NavigationStack {
            List(favoritedAlbums.reversed()) { album in
                FavoritesListRow(album: album, allListItems: favoritedAlbums.reversed())
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            withAnimation {
                                modelContext.delete(album)
                            }
                        }
                    }
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
