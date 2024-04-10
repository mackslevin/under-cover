//
//  PlaylistInfoCard.swift
//  Undercover
//
//  Created by Mack Slevin on 4/9/24.
//

import SwiftUI
import MusicKit

struct PlaylistInfoCard: View {
    let playlist: Playlist
    let conversion: () -> Void
    
    @State private var expanded = false
    @State private var tracksToShow = 1
    
    let numberOfPreviewTracks = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                AsyncImage(url: playlist.artwork?.url(width: 300, height: 300), content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                }, placeholder: {
                    Rectangle()
                        .frame(width: 150, height: 150)
                })    
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
                
                VStack(alignment: .leading) {
                    Text(playlist.name)
                        .font(.custom(Font.customFontName, size: 24))
                        .fontDesign(.none)
                    Text(playlist.curatorName ?? "")
                    Text("\(playlist.entries?.count ?? 0) \(playlist.entries?.count ?? 0 == 1 ? "song" : "songs")")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            if let tracks = playlist.tracks {
                VStack {
                    Text("Featuring")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                    
                    ForEach(tracks[0...(tracksToShow - 1)]) { track in
                        VStack(alignment: .leading) {
                            Text(track.title).bold()
                            Text(track.artistName)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                    }
                    
                    if tracks.count > numberOfPreviewTracks {
                        Button {
                            withAnimation {
                                expanded.toggle()
                            }
                        } label: {
                            Label(expanded ? "Collapse" : "Show All", systemImage: expanded ? "chevron.up" : "chevron.down")
                        }
                        .bold()
                        .buttonStyle(.bordered)
                    }
                }
                .font(.caption)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.regularMaterial)
                }
            }
            
            Button("Convert to Category", systemImage: "sparkles") {
                conversion()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.title3)
            .bold()
        }
        .onAppear {
            if let tracks = playlist.tracks {
                if tracks.count > numberOfPreviewTracks {
                    tracksToShow = numberOfPreviewTracks
                } else {
                    tracksToShow = tracks.count
                }
            }
        }
        .onChange(of: expanded) { _, newValue in
            if newValue, let tracks = playlist.tracks, tracks.count > numberOfPreviewTracks {
                withAnimation {
                    tracksToShow = tracks.count
                }
            } else {
                withAnimation {
                    tracksToShow = numberOfPreviewTracks
                }
            }
        }
    }
}

//#Preview {
//    VStack {
//        PlaylistInfoCard(){}
//            .fontDesign(.monospaced)
//    }
//    .padding()
//    
//}
