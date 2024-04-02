//
//  BasicAlbumCard.swift
//  Undercover
//
//  Created by Mack Slevin on 4/1/24.
//

import SwiftUI
import MusicKit

struct BasicAlbumCard: View {
    let ucAlbum: UCAlbum
    
    @Environment(AppleMusicController.self) var appleMusicController
    @State private var album: Album? = nil
    @State private var yearText = ""
    
    var body: some View {
        HStack {
            if let album {
                AsyncImage(url: album.artwork?.url(width: 80, height: 80)) { image in
                    image
                        .resizable().scaledToFill()
                        .frame(width: 80, height: 80)
                        .shadow(radius: 2)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                } placeholder: {
                    ProgressView()
                        .frame(width: 80, height: 80)
                }

                VStack(alignment: .leading) {
                    Text(album.title)
                        .lineLimit(1)
                    Text("by \(album.artistName)")
                        .lineLimit(1)
                    Text(yearText)
                }
                .font(.caption)
                
                Spacer()
                
//                Menu {
//                    ShareLink("Share", item: album.url!)
//                    Button("Favorite", systemImage: "star") {
//                        // TODO
//                    }
//                    Button("Open in...") {
//                        // TODO
//                    }
//                } label: {
//                    Image(systemName: "ellipsis")
//                        .resizable().scaledToFit()
//                        .frame(width: 40)
//                        .rotationEffect(.degrees(90.0))
//                }
//                .foregroundStyle(.primary)
                
                ShareLink("Share", item: album.url!)
                    .frame(width: 40)
                    .labelStyle(.iconOnly)
                    .bold()
                    .foregroundStyle(.primary)
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.quaternary)
        }
        .onAppear {
            Task {
                do {
                    album = try await appleMusicController.catalogAlbum(ucAlbum)
                    
                    if let releaseDate = album?.releaseDate {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy"
                        yearText = formatter.string(from: releaseDate)
                    }
                } catch {
                    print("^^ Error \(error.localizedDescription)")
                }
            }
        }
        .opacity(album == nil ? 0 : 1)
    }
}

//#Preview {
//    VStack {
//        BasicAlbumCard()
//    }
//    .padding()
//    .fontDesign(.monospaced)
//    
//}
