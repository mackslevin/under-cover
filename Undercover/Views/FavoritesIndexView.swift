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
            
            Group {
                if favoritedAlbums.isEmpty {
                    ContentUnavailableView("Nothing Favorited Yet", systemImage: "star.slash", description: Text("At the end of a round or game you have the option to favorite the album(s) shown. Favorites will be saved here."))
                } else {
                    List(favoritedAlbums.reversed()) { album in
                        FavoritesListRow(album: album)
                            .buttonStyle(PlainButtonStyle())
                            
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(album)
                                    }
                                }
                            }
                        
                        // Add a divider after every row but the last
                        if !(album.id == favoritedAlbums.reversed().last?.id) {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .frame(height: 1)
                                    .opacity(0.15)
                                Rectangle()
                                    .frame(height: 2)
                                    .opacity(0.07)
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listRowSpacing(0)
                    .listStyle(.plain)
                    .listRowInsets(EdgeInsets())
                }
            }
            .padding(.bottom)
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
