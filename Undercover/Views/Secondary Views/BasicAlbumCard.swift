//
//  BasicAlbumCard.swift
//  Undercover
//
//  Created by Mack Slevin on 4/1/24.
//

import SwiftUI
import MusicKit

struct BasicAlbumCard: View {
    @State var ucAlbum: UCAlbum
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
                
                HStack(spacing: 12) {
                    Button("Favorite", systemImage: ucAlbum.isFavorited ? "star.fill" : "star") {
                        withAnimation {
                            ucAlbum.isFavorited.toggle()
                        }
                    }
                    .foregroundStyle(ucAlbum.isFavorited ? .accent : .primary)
                    
                    ShareLink("Share", item: album.url!)
                        .foregroundStyle(.primary)
                }
                .bold()
                .labelStyle(.iconOnly)
                .font(.title2)
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
//        BasicAlbumCard(ucAlbum: UCAlbum(musicItemID: "1234", artistName: "Chunk Gubblits", albumTitle: "Chunking of the World", url: URL(string:"https://images.squarespace-cdn.com/content/54e35397e4b043f1c9a4b2d1/1472072556586-HR3BOOK0U2Q6CFKA8Z1O/?content-type=image%2Fjpeg")!))
//    
//    }
//    .padding()
//    .fontDesign(.monospaced)
//    .environment(AppleMusicController())
//    
//}
