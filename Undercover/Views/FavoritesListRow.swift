//
//  FavoritesListRow.swift
//  Undercover
//
//  Created by Mack Slevin on 4/18/24.
//

import SwiftUI

struct FavoritesListRow: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string:"https://images.squarespace-cdn.com/content/54e35397e4b043f1c9a4b2d1/1472072556586-HR3BOOK0U2Q6CFKA8Z1O/?content-type=image%2Fjpeg")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 1, x: 1, y: 2)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Sail Away")
                            .italic()
                        Text("by Randy Newman")
                        
                        Spacer()
                        
                        Text("From the category \"Hot 70s Daddies\"")
                            .font(.caption)
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
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button("Play", systemImage: "play.fill") {
                    print("play")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button("Share", systemImage: "square.and.arrow.up.fill") {
                    print("share")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(PlainButtonStyle())
                
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

#Preview {
    NavigationStack {
        List {
            FavoritesListRow()
            FavoritesListRow()
            FavoritesListRow()
        }
        .listRowSpacing(20)
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close", systemImage: "xmark") {
                }
            }
        }
        .fontDesign(.monospaced)
    }
}
